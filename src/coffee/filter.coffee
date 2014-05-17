app = angular.module 'kiwi.pushbullet'

app.filter 'sent', ->
	(pushes, filter) ->
		pushes.filter (e) ->
			if not filter.sent or not filter.received
				if not filter.sent and not e.isEmitted
					return false
				if not filter.received and e.isEmitted
					return false

			return true

app.filter 'contacts', ->
	(pushes, filter) ->
		return pushes if not filter.contacts
		pushes.filter (e) ->
			for el in filter.contacts
				continue if not el.checked
				if el.me is true
					if el.iden is e.target_device_iden
						return true
				else
					if el.email is e.receiver_email
						return true

			return false
		
app.filter 'type', ->
	(pushes, filter) ->
		pushes.filter (e) ->
			return filter.type[e.type]