describe 'pushkiwi - filters -', ->
	filter = mock = undefined

	# we don't want the template for now
	angular.module('templates-prod',[])
	
	beforeEach module 'kiwi.pushbullet'

	beforeEach module 'pushbullet.mock'

	beforeEach inject (ApiMock) ->
		mock = ApiMock['pushes']

	describe 'sent - ', ->
		search = undefined
		beforeEach inject (sentFilter) ->
			filter = sentFilter
			search = 
				sent: true
				received: true

		it 'should return default array', ->
			expect(filter(mock.pushes,search).length).toBe(mock.pushes.length)

		it 'should return sent pushes', ->
			search.received = false
			expect(filter(mock.pushes,search).length).toBe(mock.pushes.length-1)
			expect(filter(mock.pushes,search)[0]).toBe(mock.pushes[0])

		it 'should return received pushes', ->
			search.sent = false
			expect(filter(mock.pushes,search).length).toBe(mock.pushes.length-1)
			expect(filter(mock.pushes,search)[0]).toBe(mock.pushes[1])

		it 'should return nothing', ->
			search.sent = false
			search.received = false
			expect(filter(mock.pushes,search).length).toBe(0)

	describe 'contacts - ', ->
		search = undefined
		beforeEach inject (contactsFilter) ->
			filter = contactsFilter
			search = 
				contacts: [
					me: true
					iden: 'Any_IDEN1'
					checked: true
				,	
					me: false
					email: "any2@gmail.com"	
					checked: true
				]


		it 'should return no result', ->
			search.contacts = {}
			expect(filter(mock.pushes,search).length).toBe(0)

		it 'should return all pushes', ->
			expect(filter(mock.pushes,search).length).toBe(mock.pushes.length)
		
		it 'should not return my own devices push if not selected', ->
			search.contacts[0].checked = false
			expect(filter(mock.pushes,search).length).toBe(1)
			expect(filter(mock.pushes,search)[0]).toBe(mock.pushes[1])
		
		it 'should not return my contacts pushes if not selected', ->
			search.contacts[1].checked = false
			expect(filter(mock.pushes,search).length).toBe(1)
			expect(filter(mock.pushes,search)[0]).toBe(mock.pushes[0])

	describe 'type - ', ->
		search = undefined
		beforeEach inject (typeFilter) ->
			filter = typeFilter
			search = 
				type:
					note: true
					link: true
					list: true
					file: true
					address: true


		it 'should return everything', ->
			expect(filter(mock.pushes,search).length).toBe(mock.pushes.length)

		
		it 'should not return note pushes', ->
			# #0 is a note
			search.type.note = false
			expect(filter(mock.pushes,search).length).toBe(1)
			expect(filter(mock.pushes,search)[0]).toBe(mock.pushes[1])
		
		it 'should not return link pushes', ->
			mock.pushes[0].type = "link"
			search.type.link = false
			expect(filter(mock.pushes,search).length).toBe(1)
			expect(filter(mock.pushes,search)[0]).toBe(mock.pushes[1])

		
		it 'should not return list pushes', ->
			mock.pushes[0].type = "list"
			search.type.list = false
			expect(filter(mock.pushes,search).length).toBe(1)
			expect(filter(mock.pushes,search)[0]).toBe(mock.pushes[1])
		
		it 'should not return file pushes', ->
			mock.pushes[0].type = "file"
			search.type.file = false
			expect(filter(mock.pushes,search).length).toBe(1)
			expect(filter(mock.pushes,search)[0]).toBe(mock.pushes[1])
		
		it 'should not return address pushes', ->
			# #1 is an address
			search.type.address = false
			expect(filter(mock.pushes,search).length).toBe(1)
			expect(filter(mock.pushes,search)[0]).toBe(mock.pushes[0])
