app = angular.module 'kiwi.pushbullet'

app.provider 'pushbulletService', ->
	provider = {}

	# not used yet
	provider.API_KEY = null

	provider.API_ENDPOINT = 'https://api.pushbullet.com/v2/'

	provider.$get = ($http, Base64, $q, User) ->
		# app.factory 'pushbulletService', ($state, $q, $http, Base64, User) ->

		$scope = {}

		$http.defaults.headers.post['Content-Type'] = "application/json"


		$scope.query = (path,method="GET",params) ->
			headers = 
				Authorization: "Basic "+Base64.encode(User.API_KEY+':') 

			deferred = $q.defer()

			data = JSON.stringify(params)

			url = provider.API_ENDPOINT + encodeURI(path)

			promise = $http({method,url,data,headers})

			promise.success (data) ->
				deferred.resolve(data)

			promise.error ->
				deferred.reject('ERROR',url,method,params,headers,arguments)

			return deferred.promise

		$scope.getContacts = ->
			deferred = $q.defer()

			$q.all([
				$scope.query('contacts')
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

	return provider

app.service 'MyPushes', (pushbulletService) ->
	$scope = {}

	_ = _ || global._

	$scope._save = ->
		data = 
			pushes: $scope._data
			lastUpdatedAt: $scope._lastUpdatedAt

		localStorage.setItem('kiwi.pushes', JSON.stringify(data))

	$scope._load = ->
		ls = localStorage.getItem('kiwi.pushes')
		if not ls
			$scope._lastUpdatedAt = 0
			$scope._data = []
			$scope._dataIndexed = {}
		else
			data = JSON.parse(ls)
			$scope._lastUpdatedAt = data.lastUpdatedAt
			$scope._data = data.pushes
			$scope._dataIndexed = {}

			for push in $scope._data
				$scope._dataIndexed[push.iden] = push

	$scope._index = ->		
	$scope._actualize = ->
		pushbulletService.query('pushes?modified_after='+$scope._lastUpdatedAt).then (result) ->
			for push in result.pushes
				$scope._updateOne(push)

			$scope._lastUpdatedAt = result.timestamp
			$scope._save()



	$scope.filter = (filters={}) ->
		$scope._data
	$scope.get = $scope.filter

		
	$scope._updateOne = (push) ->
		if push.active is false and $scope._dataIndexed[push.iden]?
			index = $scope._data.indexOf($scope._dataIndexed[push.iden])
			$scope._data.splice(index,1)
		if push.active is true and not $scope._dataIndexed[push.iden]?
			$scope._data.unshift(push)
			$scope._dataIndexed[push.iden] = push
		_.merge($scope._dataIndexed[push.iden],push)

	$scope._load()

	return $scope

