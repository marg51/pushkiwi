app = angular.module 'kiwi.pushbullet'

app.factory 'pushbulletWsService', (configFactory, $state, $q, $rootScope) ->

	ready = false
	WebSocket = require('ws')
	$scope = {}

	$scope.checkKey = ->
		config = configFactory.get('pushbullet')
		if not config or not config.key or config.key.length isnt 45
			$state.go 'config'
			return false
		return config.key

	$scope.connect = ->
		return if not (key = $scope.checkKey())

		deferred = $q.defer()

		if ready is true
			deferred.resolve(true)
		else
			ws = new WebSocket("wss://websocket.pushbullet.com/subscribe/#{key}")
			# ws = new WebSocket("ws://localhost:1338")
			ws.on 'open', ->
				console.log 'opened'
				ready = true
				deferred.resolve(true)
			ws.on 'close', ->
				console.log 'closed'
				if ready is false
					deferred.reject("Can not connect to WS server")
				ready = false
			ws.on 'message', (data, flags) ->
				console.log 'message', data, flags
				if data isnt '{"type": "nop"}'
					$rootScope.$emit('pushbullet:ws:message',{data,flags})
					$rootScope.$digest()

		return deferred.promise

	return $scope


app.factory 'pushbulletService', (configFactory,$state, $q) ->

	$scope = {}

	https = require('https')
	Buffer = require('buffer')
	options=
		hostname: 'api.pushbullet.com'
		path: '/v2/'
		method: 'GET'
		port: 443


	$scope.getKey = ->
		config = configFactory.get('pushbullet')
		if not config or not config.key or config.key.length isnt 45
			$state.go 'config'
		else
			config.key

	$scope.query = (what,method="GET",params={}) ->
		deferred = $q.defer()

		params = JSON.stringify(params)

		_options = angular.copy options
		_options.path+=what
		_options.auth = $scope.getKey()+':'

		if method is 'POST'
			_options.headers =
				"Content-Type": "application/json"
				# "Content-Length": Buffer.byteLength(params)
				"Content-Length": params.length

		_options.method = method

		req = https.request _options, (res) ->
			data = ''
			res.on 'data', (chunck) ->
				data+=chunck.toString()

			res.on 'end', ->
				deferred.resolve(data)

		req.end(params)
		req.on 'error', (e) ->
			deferred.reject(e) 

		return deferred.promise

	return $scope
		
