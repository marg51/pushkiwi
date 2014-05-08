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


app.factory 'pushbulletService', ($state, $q, require, $http, Base64, User) ->

	$scope = {}

	# @todo We should use angular's $http instead
	# https = require('https')
	# Buffer = require('buffer')
	API_ENDPOINT= 'https://api.pushbullet.com/v2/'

	$scope.getAuth = ->
		# User.getUser().api_key
		"Basic "+Base64.encode(User.API_KEY+':')

	$http.defaults.headers.common["Authorization"] = $scope.getAuth()
	$http.defaults.headers.post['Content-Type'] = "application/json"


	$scope.query = (path,method="GET",params) ->
		deferred = $q.defer()

		data = JSON.stringify(params)

		url=API_ENDPOINT+path

		promise = $http({method,url,data})
		promise.success (data) ->
			deferred.resolve(data)
		promise.error () ->
			deferred.reject('ERROR',url,method,params,arguments)

		return deferred.promise

	$scope.getContacts = ->
		deferred = $q.defer()
		$q.all([
			$scope.query('contacts'),
			$scope.query('devices')

		]).then((results) ->
			list = []
			
			for el in results[0].contacts
				list.push {iden:el.iden,name:el.name, email: el.email, me: false}
			for el in results[1].devices
				list.push {iden:el.iden,name:el.nickname, email: '', me: true}

			deferred.resolve(list)
		).catch (e) ->
			deferred.reject(e)

		return deferred.promise

	return $scope
		
