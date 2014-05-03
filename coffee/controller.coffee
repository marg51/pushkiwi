app = angular.module 'kiwi.pushbullet'


app.controller 'PushbulletCtrl', ($scope,pushbulletWsService,pushbulletService,$rootScope) ->
	http = require('http')
	$rootScope.$on 'pushbullet:ws:message', (e,obj) ->
		data = JSON.parse(obj.data)
		if data.type is "tickle" and data.subtype is "push"
			pushbulletService.query("pushes").then (data) ->
				data = JSON.parse(data).pushes
				http.get("http://localhost:1337/info?message=#{data[0].title}")


app.controller 'PushbulletListCtrl', ($scope, pushbulletService, $rootScope, configFactory) ->
	$scope.list = []
	$scope.config = configFactory.get('pushbullet')
	# give the scope to the directives
	$scope.ctrl = $scope 
	$scope.timestamp = 0
	$scope.actualize = ->
		pushbulletService.query("pushes").then (data) ->
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
		pushbulletService.query("pushes/#{$scope.list[index].iden}",'DELETE')
		$scope.list.splice(index,1)
			