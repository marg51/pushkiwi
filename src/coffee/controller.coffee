app = angular.module 'kiwi.pushbullet'

# default controller, called inside the main view, index.html
app.controller 'MainCtrl', ($scope,$rootScope,$state) ->
	$scope.nodeVersion = process.version
	$rootScope.$on '$stateChangeError', (event, toState, toParams, fromState, fromParams, error) ->
		if error? then console.log "error", error
		$scope.errorMessage = if error.message then error.stack else error
		# $scope.toState = toState
		if error is "User not authenticated"
			$state.go('login')
		else
			$state.go('error')

# Ask the user his API_KEY
app.controller 'LoginCtrl', ($scope, pushbulletService,$state,User) ->
	$scope.form = {key:''}
	$scope.login = ->
		$scope.message = ""
		$scope.connect = true
		User.API_KEY = $scope.form.key
		# if we can query with success, the API KEY is valid
		pushbulletService.query('users/me').then (data) ->
			user = data
			if not user.error?
				$scope.connect = false
				localStorage.setItem 'pushkiwi.user', JSON.stringify user
				$state.go 'pushbullet.list'
			else
				console.log "can not connect user", user
				$scope.connect = false
				$scope.message = "Try again"

# We remove data from localStorage
app.controller 'LogoutCtrl', ($scope, pushbulletService,$state) ->
	# pushkiwi.user is the result of /users/me, including API_KEY
	localStorage.setItem('pushkiwi.user',null)
	# pushkiwi.pushes is the result of /pushes
	localStorage.setItem('pushkiwi.pushes',null)
	$state.go 'login'


app.controller 'PushbulletCtrl', ($scope,pushbulletWsService,pushbulletService,MyPushes,$rootScope,user, $http) ->

	# array of notifs
	$scope.list = MyPushes.get()
	# Allow directives to access this scope easily
	$scope.ctrl = $scope 
	$scope.user = user


	$rootScope.$on 'pushbullet:new', (e,push) ->
		$http.get("http://localhost:1337/info?message=#{push.title}")

	MyPushes._actualize()

	# Socket say something
	$rootScope.$on 'pushbullet:ws:message', (e,obj) ->
		data = obj.data
		if data.type is "tickle" and data.subtype is "push"
			MyPushes._actualize()

	# retrieve friends and own devices
	pushbulletService.getContacts().then (list) ->
		$scope.contacts = list
		
app.controller 'PushbulletListCtrl', ($scope, pushbulletService, $rootScope) ->

app.controller 'PushbulletAddCtrl', ($scope,pushbulletService,$state,$q, $animate) ->
	$scope.form = {}
	_preSave = angular.noop

	# <div> which has list of contacts, animated when no contact selected
	# I'm not sure where the best place is. In a new directive ?
	$dom_contacts = undefined

	# call the `fn` function at the beginning of $scope.save()
	# `fn` is set to angular.noop by $scope.init()
	$scope.preSave = (fn) ->
		_preSave = fn

	$scope.save = ->
		_preSave()

		if not $dom_contacts
			$dom_contacts = angular.element(document.querySelector('#contacts'))

		# Every dest checked
		to = $scope.contacts.filter (e)=>e.checked

		# No dest ?
		if to.length is 0
			$animate.addClass $dom_contacts,'flash', ->
				$dom_contacts.removeClass 'flash'
			return 

		$scope.send = true
		$scope.nb_dest = to.length
		# number of pushes sent
		$scope.sent = 0

		# for every dest
		to.map (e) ->
			# My own device ?
			if e.me is true
				$scope.form.device_iden = e.iden
			# a friend
			else
				$scope.form.email = e.email 

			pushbulletService.query('pushes','POST',$scope.form).then -> 
				$scope.sent++
				# if every push is done. @todo use Q.all([])
				if $scope.sent is $scope.nb_dest
					$scope.send = false
					$state.go('pushbullet.list')

	# called by PushbulletAddItemCtrl, => when we select another type of push
	$scope.init = ->
		$scope.form = {}
		$scope.preSave(angular.noop)


app.controller 'PushbulletAddItemCtrl', ($scope,$state) ->
	$scope.init()
	# the type is guessed, based on the url
	$scope.form.type = $state.current.url.slice(1)

	if $scope.form.type is 'list'
		$scope.form.items = []

		$scope.addItem = ->
			# PB does not support this version yet
			# $scope.form.items.push {checked:false,text:''}
			$scope.form.items.push ''

		$scope.onItemChange = (index)->
			if index is $scope.form.items.length - 1
				$scope.addItem()

		$scope.preSave ->
			console.log 'preSave'
			for el,key in $scope.form.items
				if el is ''
					$scope.form.items.splice(key,1)

		# default: 2 rows
		$scope.addItem()
		$scope.addItem()



			