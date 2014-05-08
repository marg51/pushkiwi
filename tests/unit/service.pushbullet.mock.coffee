app = angular.module 'pushbullet.mock', []

app.factory 'ApiMock', ->
	'pushes':
		"cursor": null,
		"timestamp": 1399569310.0708301,
		"pushes": [
			{
				"notification_id": null,
				"iden": "Any_IDEN",
				"package_name": null,
				"file_type": "",
				"sender_email_normalized": "@gmail.com",
				"notification_tag": null,
				"receiver_iden": "Any_IDEN",
				"id": 133769,
				"receiver_email_normalized": "any@gmail.com",
				"title": "salut",
				"target_device_id": 54,
				"dismissed": false,
				"dismissable": null,
				"receiver_email": "any@gmail.com",
				"notification_duration": 0,
				"file_name": "",
				"type": "note",
				"body": "glad you read me",
				"receiver_id": 133742,
				"source_device_id": null,
				"sender_id": 133742,
				"target_device_iden": "Any_IDEN",
				"address": "",
				"active": true,
				"sender_iden": "Any_IDEN",
				"icon": null,
				"account": "any@gmail.com",
				"owner_iden": "Any_IDEN",
				"name": "",
				"created": 1399559244.5720799,
				"url": "",
				"items": [],
				"file_url": null,
				"modified": 1399559244.5720999,
				"sender_email": "any@gmail.com",
				"application_name": null,
				"source_device_iden": null
			}
		]
	