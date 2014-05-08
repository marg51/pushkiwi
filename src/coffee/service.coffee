app = angular.module 'kiwi.pushbullet'

app.factory 'pushbulletWsService', ($state, $q, $rootScope, require) ->

	ready = false
	WebSocket = require('ws')
	$scope = {}


	$scope.connect = (user) ->
		deferred = $q.defer()

		if not user? or not user.api_key
			deferred.reject('Where is my API_KEY ?')

		if ready is true
			deferred.resolve(true)
		else
			ws = new WebSocket("wss://websocket.pushbullet.com/subscribe/#{user.api_key}")
			# $ wscat -l 1338
			# ws = new WebSocket("ws://localhost:1338")
			ws.on 'open', ->
				if console? then console.log 'opened'
				ready = true
				deferred.resolve(true)
			ws.on 'close', ->
				if console? then console.log 'closed'
				if ready is false
					deferred.reject("Can not connect to WS server")
				ready = false
			ws.on 'message', (data, flags) ->
				if console? then console.log 'message', data, flags
				if data isnt '{"type": "nop"}'
					$rootScope.$emit('pushbullet:ws:message',{data,flags})
					$rootScope.$digest()

		return deferred.promise

	return $scope


app.factory 'pushbulletService', ($state, $q, require) ->

	$scope = {}

	# @todo We should use angular's $http instead
	https = require('https')
	Buffer = require('buffer')
	options=
		hostname: 'api.pushbullet.com'
		path: '/v2/'
		method: 'GET'
		port: 443


	$scope.getKey = ->
		# User.getUser().api_key
		$scope._key


	$scope.setKey = (key) ->
		$scope._key = key
		$scope

	$scope.query = (what,method="GET",params) ->
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
			res.on 'error', (e) ->
				deferred.reject(e)

		req.end(params)
		req.on 'error', (e) ->
			deferred.reject(e) 

		return deferred.promise

	$scope.getContacts = ->
		deferred = $q.defer()
		$q.all([
			$scope.query('contacts'),
			$scope.query('devices')

		]).then((results) ->
			list = []
			
			for el in JSON.parse(results[0]).contacts
				list.push {iden:el.iden,name:el.name, email: el.email, me: false}
			for el in JSON.parse(results[1]).devices
				list.push {iden:el.iden,name:el.nickname, email: '', me: true}

			deferred.resolve(list)
		).catch (e) ->
			deferred.reject(e)

		return deferred.promise

	return $scope
		
