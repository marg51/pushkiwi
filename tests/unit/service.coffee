# describe 'pushkiwi - Services -', ->
# 	$scope = service = undefined

# 	# we don't want the template for now
# 	angular.module('templates-prod',[])
	
# 	beforeEach module 'app'

# 	beforeEach module 'uto.mock-require'

# 	beforeEach inject (require) ->
# 		require.add 'moment', -> return -> {from:angular.noop()}


# 	describe 'pushbulletService - ', ->
# 		beforeEach inject (pushbulletService) ->
# 			service = pushbulletService

# 		describe 'key - ', ->

# 			it 'should be set by .setKey()', ->
# 				service.setKey('mock')
# 				expect(service._key).toBe 'mock'
# 			it 'should be accessible with .getKey()', ->
# 				service._key = 'mocked'
# 				expect(service.getKey()).toBe 'mocked'
