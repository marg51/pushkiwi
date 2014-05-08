# EXPORTED FROM PROJECT KIWI, should be rewritten

app = angular.module 'app', [
	'ui.router'
	'ngAnimate'
	'uto.flexbox'
	'uto.require'
	'templates-prod'
	'kiwi.pushbullet'
	'chieffancypants.loadingBar'
]

app.config ($stateProvider, $urlRouterProvider) ->
	$stateProvider.state("login",
		url: "/login"
		templateUrl: "tmpl-login.html"
		controller: "LoginCtrl"
	)
	.state("logout",
		url: "/logout"
		templateUrl: ""
		controller: "LogoutCtrl"
	).state("error",
		url: "/error"
		templateUrl: "tmpl-error.html"
	)

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

app.controller 'LoginCtrl', ($scope, pushbulletService,$state,User) ->
	$scope.form = {key:''}
	$scope.login = ->
		$scope.message = ""
		$scope.connect = true
		User.API_KEY = $scope.form.key
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
app.controller 'LogoutCtrl', ($scope, pushbulletService,$state) ->
	localStorage.setItem('pushkiwi.user',null)
	localStorage.setItem('pushkiwi.pushes',null)
	$state.go 'login'

app.factory 'User', ($q) ->
	$scope = {}

	$scope.getUser = ->

		deferred = $q.defer()
		ls = localStorage.getItem('pushkiwi.user')
		if not ls or not (data = JSON.parse(ls)).api_key
			deferred.reject("User not authenticated")
		else
			$scope.API_KEY = data.api_key
			deferred.resolve(data)

		return deferred.promise


	return $scope
