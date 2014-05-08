app = angular.module 'kiwi.pushbullet'

app.factory 'pushbulletWsService', ($state, $q, $rootScope, require, $timeout, User) ->

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


app.factory 'pushbulletService', ($state, $q, require, $http, Base64, User) ->

	$scope = {}

	# @todo We should use angular's $http instead
	# https = require('https')
	# Buffer = require('buffer')
	API_ENDPOINT= 'https://api.pushbullet.com/v2/'

	$scope.getAuth = ->
		# User.getUser().api_key
		"Basic "+Base64.encode(User.API_KEY+':')

	$http.defaults.headers.post['Content-Type'] = "application/json"


	$scope.query = (path,method="GET",params) ->
		$http.defaults.headers.common["Authorization"] = $scope.getAuth()
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
		
