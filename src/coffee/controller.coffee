app = angular.module 'kiwi.pushbullet'


app.controller 'PushbulletCtrl', ($scope,pushbulletWsService,pushbulletService,$rootScope) ->
	http = require('http')
	$rootScope.$on 'pushbullet:ws:message', (e,obj) ->
		data = JSON.parse(obj.data)
		if data.type is "tickle" and data.subtype is "push"
			pushbulletService.query("pushes").then (data) ->
				data = JSON.parse(data).pushes
				try
					# it will fail, even in the try catch, if `node-osx-notifier 1>/dev/null 2>&1 &` isnt started
					http.get("http://localhost:1337/info?message=#{data[0].title}")
				catch e
					console.log e
		
app.controller 'PushbulletListCtrl', ($scope, pushbulletService, $rootScope, user) ->
	# List of notifs
	$scope.list = []
	# give the scope to the directives
	$scope.ctrl = $scope 
	$scope.user = user

	# last fetched time
	$scope.timestamp = 0
	$scope.actualize = ->
		pushbulletService.query("pushes").then (data) ->
			console.log data
			data = JSON.parse(data)
			i = data.pushes.length - 1
			while i >= 0
				el = data.pushes[i]
				if el.created > $scope.timestamp and el.active is true
					$scope.list.unshift(el)
				i--
			$scope.timestamp = data.timestamp
	$scope.actualize()

	$rootScope.$on 'pushbullet:ws:message', (e,obj) ->
		data = JSON.parse(obj.data)
		if data.type is "tickle" and data.subtype is "push"
			$scope.actualize()

	$scope.delete = (index) ->
		console.log index
		return if not $scope.list[index]?
		pushbulletService.query("pushes/#{$scope.list[index].iden}",'DELETE').then ->
			$scope.list.splice(index,1)

app.controller 'PushbulletAddCtrl', ($scope,pushbulletService,$state,$q) ->
	pushbulletService.getContacts().then (list) ->
		$scope.contacts = list

	$scope.form = {}
	$scope._save = ->
		$scope.send = true
		to = $scope.contacts.filter (e)=>e.checked

		$scope.nb_dest = to.length
		$scope.sent = 0

		to.map (e) ->
			# My own device ?
			if e.me is true
				$scope.form.device_iden = e.iden
			else
				$scope.form.email = e.email 

			console.log $scope.form
			pushbulletService.query('pushes','POST',$scope.form).then -> 
				$scope.sent++
				if $scope.sent is $scope.nb_dest
					$scope.send = false
					$state.go('pushbullet.list')

	$scope.init = ->
		$scope.form = {}
		$scope.save = $scope._save


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

		$scope.$parent.save = ->
			for el,key in $scope.form.items
				if el is ''
					$scope.form.items.splice(key,1)

			$scope.$parent._save()

		# default: 2 rows
		$scope.addItem()
		$scope.addItem()



			