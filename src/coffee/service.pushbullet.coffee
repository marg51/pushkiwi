app = angular.module 'kiwi.pushbullet'

app.provider 'pushbulletService', ->
	provider = {}

	# not used yet
	provider.API_KEY = null

	provider.API_ENDPOINT = 'https://api.pushbullet.com/v2/'

	provider.$get = ($http, Base64, $q, User, $rootScope) ->
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

		$scope.getFileStat = (path) ->
			return if not require
			mime = require('mime')
			type = mime.lookup(path)

			tmp = path.split('/')
			name = tmp[tmp.length-1]

			{name,path,type}

		$scope.uploadFile = (file) ->
			deferred = $q.defer()
			if not require
				deferred.reject("Not in Node.JS env")

			$scope.query("upload-request?file_name=#{file.name}&file_type=#{file.type}").then (result) ->
				$scope._uploadFile(file,result)
				

			return deferred.promise

		$scope._uploadFile = (file, result) ->
			data = result.data
			command = "curl -i #{result.upload_url}
 -F awsaccesskeyid=#{data.awsaccesskeyid}
 -F acl=#{data.acl}
 -F key=#{data.key}
 -F signature=#{data.signature}
 -F policy=#{data.policy}
 -F content-type=#{file.type}
 -F file=@#{file.path}"

			spawn = require('child_process').exec
			spawn command, (err, stdout, stderr) ->
				deferred.resolve(result.file_url)
				$rootScope.$apply()


		return $scope

	return provider

app.service 'MyPushes', (pushbulletService, $rootScope, _) ->
	$scope = {}

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

			$scope._lastUpdatedAt = data.lastUpdatedAt || 0
			$scope._data = []
			$scope._dataIndexed = {}

			for el in data.pushes
				# don't keep AngularJS infos
				push = _.omit(el,'$$hashKey')
				$scope._data.push(push)
				$scope._dataIndexed[push.iden] = push

				# timestamp is not sent anymore, we keep the oldest timestamp
				if el.modified > $scope._lastUpdatedAt
					$scope._lastUpdatedAt = el.modified

	$scope._index = ->		

	# @todo should not allow concurrent _actualize 
	$scope._actualize = ->
		pushbulletService.query('pushes?modified_after='+$scope._lastUpdatedAt).then (result) ->
			for push in result.pushes
				$scope._updateOne(push)

			for el in result.pushes
				# timestamp is not sent anymore, we keep the oldest timestamp
				if el.modified > $scope._lastUpdatedAt
					$scope._lastUpdatedAt = el.modified

			$scope._save()


	$scope.filter = (filters={}) ->
		$scope._data
	$scope.get = $scope.filter

	$scope.delete = (push) ->
		pushbulletService.query("pushes/#{push.iden}",'DELETE').then (result) ->
		
	$scope._updateOne = (push) ->
		if push.active is false and $scope._dataIndexed[push.iden]?
			index = $scope._data.indexOf($scope._dataIndexed[push.iden])
			$scope._data.splice(index,1)
		if push.active is true and not $scope._dataIndexed[push.iden]?
			$scope._data.unshift(push)
			$scope._dataIndexed[push.iden] = push
			if $scope._lastUpdatedAt isnt 0
				$rootScope.$emit('pushbullet:new',push)
		_.merge($scope._dataIndexed[push.iden],push)

	$scope._load()

	return $scope

