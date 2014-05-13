app = angular.module 'kiwi.pushbullet'

app.factory 'pushbulletWsService', ($state, $q, $rootScope, $timeout, User) ->

	ready = false
	WebSocket = require('ws')
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
		
