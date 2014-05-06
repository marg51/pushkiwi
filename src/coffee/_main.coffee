app = angular.module 'app', [
	'ui.router'
	'ngAnimate'
	'uto.flexbox'
	'uto.require'
	'templates-prod'
	'kiwi.pushbullet'
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
		$scope.errorMessage = error
		# $scope.toState = toState
		if error is "User not authenticated"
			$state.go('login')
		else
			$state.go('error')

app.controller 'LoginCtrl', ($scope, pushbulletService,$state) ->
	$scope.form = {}
	$scope.login = ->
		console.log 'login', $scope.form
		$scope.connect = true
		pushbulletService.setKey($scope.form.key).query('users/me').then (data) ->
			user = JSON.parse(data)
			if not user.error?
				$scope.connect = false
				localStorage.setItem 'pushkiwi.user', data
				$state.go 'pushbullet.list'
			else
				console.log user
app.controller 'LogoutCtrl', ($scope, pushbulletService,$state) ->
	localStorage.setItem('pushkiwi.user',null)
	$state.go 'login'

app.factory 'User', ($q,pushbulletService) ->
	$scope = {}

	$scope.getUser = ->

		deferred = $q.defer()
		ls = localStorage.getItem('pushkiwi.user')
		if not ls or not (data = JSON.parse(ls)).api_key
			deferred.reject("User not authenticated")
		else
			pushbulletService.setKey(data.api_key)
			deferred.resolve(data)

		return deferred.promise


	return $scope