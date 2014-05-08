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
			

