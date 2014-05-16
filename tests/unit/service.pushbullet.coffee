describe 'pushkiwi - Services -', ->
	$scope = service = mock = $httpBackend = undefined

	API_ENDPOINT = 'https://api.pushbullet.com/v2/'

	# we don't want the template for now
	angular.module('templates-prod',[])
	
	beforeEach module 'app'

	beforeEach module 'pushbullet.mock'

	beforeEach inject (_$httpBackend_,ApiMock) ->
		$httpBackend = _$httpBackend_
		mock = ApiMock

	describe 'pushbulletService - ', ->
		beforeEach inject (pushbulletService) ->
			service = pushbulletService

		describe 'query()', ->

			describe 'conf $http', ->
				it 'should make a query', ->
					$httpBackend.expectGET(API_ENDPOINT+'pushes').respond('')
					service.query('pushes')

					$httpBackend.flush()

				it 'should define Authorization header', ->
					$httpBackend.expectGET(API_ENDPOINT+'pushes',(headers)->
						# API_KEY is empty, here is the base64
						headers['Authorization'] == 'Basic dW5kZWZpbmVkOg=='
					).respond('')
					service.query('pushes')

					$httpBackend.flush()

				it 'should make a POST query', ->
					$httpBackend.expectPOST(API_ENDPOINT+'pushes').respond('')
					service.query('pushes','POST')

					$httpBackend.flush()

				it 'should define Authorization header for POST request', ->
					$httpBackend.expectPOST(API_ENDPOINT+'pushes',undefined, (headers)->
						# API_KEY is empty, here is the base64
						headers['Authorization'] == 'Basic dW5kZWZpbmVkOg=='
					).respond('')

					service.query('pushes','POST')

					$httpBackend.flush()

				it 'should make a DELETE query', ->
					$httpBackend.expectDELETE(API_ENDPOINT+'pushes').respond('')
					service.query('pushes','DELETE')

					$httpBackend.flush()

				it 'should define Authorization header for DELETE request', ->
					$httpBackend.expectDELETE(API_ENDPOINT+'pushes', (headers)->
						# API_KEY is empty, here is the base64
						headers['Authorization'] == 'Basic dW5kZWZpbmVkOg=='
					).respond('')

					service.query('pushes','DELETE')
					$httpBackend.flush()

			describe 'result -', ->
				it 'should return the obj', ->
					mocked = false
					$httpBackend.expectGET(API_ENDPOINT+'pushes').respond({mock:'hola'})
					service.query('pushes').then (data) ->
						mocked = data.mock

					$httpBackend.flush()
					expect(mocked).toBe 'hola'

			# @todo test resolve/reject scenarii


		describe 'getContacts() -', ->
			it 'should query both /devices and /contacts', ->
				$httpBackend.expectGET(API_ENDPOINT+'contacts').respond({contacts:[]})
				$httpBackend.expectGET(API_ENDPOINT+'devices').respond({devices:[]})

				service.getContacts()

				$httpBackend.flush()

			it 'should return an array of dest', ->
				number = false

				$httpBackend.expectGET(API_ENDPOINT+'contacts').respond({contacts:[{},{}]})
				$httpBackend.expectGET(API_ENDPOINT+'devices').respond({devices:[{},{},{}]})

				service.getContacts().then (dest) ->
					number = dest.length

				$httpBackend.flush()
				expect(number).toBe 5

			it 'should set me:true to my devices', ->
				called = false
				$httpBackend.expectGET(API_ENDPOINT+'contacts').respond({contacts:[{},{}]})
				$httpBackend.expectGET(API_ENDPOINT+'devices').respond({devices:[{},{},{}]})

				service.getContacts().then (dest) ->
					called = true
					expect(dest[0].me).toBe false
					expect(dest[1].me).toBe false
					expect(dest[2].me).toBe true
					expect(dest[3].me).toBe true
					expect(dest[4].me).toBe true

				$httpBackend.flush()
				expect(called).toBe true
				

	describe 'MyPushes - ', ->
		beforeEach inject (MyPushes) ->
			service = MyPushes

		describe '_actualize', ->
			beforeEach ->
				service._lastUpdatedAt = 0
				$httpBackend.expectGET(API_ENDPOINT+'pushes?modified_after=0').respond(mock['pushes'])

			it 'should query pushes?modified_after', ->
				service._actualize()

				$httpBackend.flush()

			it 'should call _updateOne', ->
				spyOn(service,'_updateOne')

				service._actualize()

				$httpBackend.flush()

				expect(service._updateOne).toHaveBeenCalledWith(mock['pushes'].pushes[0])

			it 'should update _lastUpdatedAt', ->
				service._actualize()

				$httpBackend.flush()

				expect(service._lastUpdatedAt).toBe(mock['pushes'].pushes[0].modified)

			it 'should call _save', ->
				spyOn(service,'_save')

				service._actualize()

				$httpBackend.flush()

				expect(service._save).toHaveBeenCalled()

		describe 'delete() - ', ->
			beforeEach ->
				service._load()
			it 'should query /pushes/IDEN with method DELETE', ->
				$httpBackend.expectDELETE(API_ENDPOINT+'pushes/'+mock['pushes'].pushes[0].iden).respond({})
				service.delete(mock['pushes'].pushes[0])

				$httpBackend.flush()

			# actually, this is already managed by the socket which trigger a new _actualize()
			xit 'should remove it', ->
				$httpBackend.expectDELETE(API_ENDPOINT+'pushes/'+mock['pushes'].pushes[0].iden).respond({})
				service.delete(mock['pushes'].pushes[0])

				$httpBackend.flush()

				expect(service._data.length).toBe 0

		describe '_updateOne', ->
			it 'should update pushes', ->
			it 'should remove elements', ->
			it 'should add elements', ->

			


				