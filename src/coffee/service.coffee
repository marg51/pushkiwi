app = angular.module 'kiwi.pushbullet'


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


app.factory 'pushbulletWsService', ($state, $q, $rootScope, $timeout, User) ->

	ready = false
	if require?
		WebSocket = require('ws')
	else
		WebSocket = {}
	$scope = {}
	$scope.RETRY_AFTER = 5

	$scope._connect = (deferred) ->
		

		return ws

	$scope.connect =  ->
		deferred = $q.defer()

		if not User? or not User.API_KEY
			deferred.reject('Where is my API_KEY ?')

		if ready is true
			return true
		else
			try
				ws = new WebSocket("wss://websocket.pushbullet.com/subscribe/#{User.API_KEY}")
				# $ wscat -l 1338
				# ws = new WebSocket("ws://localhost:1338/")
				ws.on 'open', ->
					ready = true
					$rootScope.$emit('pushbullet:ws:opened')

				ws.on 'error', (e) ->
					$rootScope.$emit('pushbullet:ws:error',e)
					$timeout $scope.connect, $scope.RETRY_AFTER*1000

				ws.on 'close', ->
					ready = false
					$rootScope.$emit('pushbullet:ws:closed')
					$timeout $scope.connect, $scope.RETRY_AFTER*1000
					
				ws.on 'message', (data, flags) ->
					if data isnt '{"type": "nop"}'
						$rootScope.$emit('pushbullet:ws:message',{data: JSON.parse(data), flags: flags})
			catch e
				console.log e

		return true

	return $scope

app.factory '_', ->
	if global? and global._?
		return global._
	if _?
		return _
	throw new Error('No lodash found')
		
