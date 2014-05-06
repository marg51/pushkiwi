app = angular.module 'app', [
	'app.service'

	'ui.router'
	'ngAnimate'
	'uto.ssh'
	'uto.flexbox'
	'templates-prod'
	'kiwi.pushbullet'
]

app.config ($stateProvider, $urlRouterProvider) ->
	$stateProvider.state("login",
		url: "/login"
		templateUrl: "tmpl-login.html"
		controller: "LoginCtrl"
	)

app.controller 'MainCtrl', ($scope,$rootScope,$state) ->
	$scope.nodeVersion = process.version
	$rootScope.$on '$stateChangeError', (event, toState, toParams, fromState, fromParams, error) ->
		if error? then console.log "error", error
		$scope.errorMessage = error
		# $scope.toState = toState
		$state.go('login')

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
				$state.go 'pushbullet'
			else
				console.log user

app.factory 'User', ($q,pushbulletService) ->
	$scope = {}

	$scope.getUser = ->

		deferred = $q.defer()
		ls = localStorage.getItem('pushkiwi.user')
		if not ls
			deferred.reject("User not authenticated")
		else
			data = JSON.parse(ls)
			pushbulletService.setKey(data.api_key)
			deferred.resolve(data)

		return deferred.promise


	return $scope
