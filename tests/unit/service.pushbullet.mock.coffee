app = angular.module 'pushbullet.mock', []

app.factory 'ApiMock', ->
	'pushes':
		"cursor": null,
		"pushes": [
			{	
				"_isEmitted": true, # OWN property
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
				"target_device_iden": "Any_IDEN1",
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
			{
				"_isEmitted": false, # OWN property
				"notification_id": null,
				"iden": "Any_IDEN",
				"package_name": null,
				"file_type": "",
				"sender_email_normalized": "@gmail.com",
				"notification_tag": null,
				"receiver_iden": "Any_IDEN",
				"id": 133770,
				"receiver_email_normalized": "any@gmail.com",
				"title": "salut",
				"target_device_id": 54,
				"dismissed": false,
				"dismissable": null,
				"receiver_email": "any2@gmail.com",
				"notification_duration": 0,
				"file_name": "",
				"type": "address",
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
				"created": 1399529244.5720799,
				"url": "",
				"items": [],
				"file_url": null,
				"modified": 1399551044.5720999,
				"sender_email": "any@gmail.com",
				"application_name": null,
				"source_device_iden": null
			}
		]
	'upload-request':[
		"file_type":"image/png"
		"file_name":"image.png"
		"file_url":"https://s3.amazonaws.com/pushbullet-uploads/ubd-VWb1dP5XrZzvHReWHCycIwPyuAMp2R9I/image.png"
		"upload_url":"https://s3.amazonaws.com/pushbullet-uploads"
		"data":
			"awsaccesskeyid":"AKIAJJIUQPUDGPM4GD3W"
			"acl":"public-read"
			"key":"ubd-CWb1dP5XrZzvHReWHCycIwPyuAMp2R9I/image.png"
			"signature":"UX5s1uIy1ov6+xlj58JY7rGFKcs="
			"policy":"eyKjb25kaXRpb25zIjogW3siYnVja2V0IjogInB1c2hidWxsZXQtdXBsb2FkcyJ9LCB7ImtleSI6ICJ1YmQtVldiMWRQNVhyWnp2SFJlV0hDeWNJd1B5dUFNcDJSOUkvaW1hZ2UucG5nIn0sIHsiYWNsIjogInB1YmxpYy1yZWFkIn0sIFsiY29udGVudC1sZW5ndGgtcmFuZ2UiLCAxLCAyNjIxNDQwMF0sIFsiZXEiLCAiJENvbnRlbnQtVHlwZSIsICJpbWFnZS9wbmciXV0sICJleHBpcmF0aW9uIjogIjIwMTQtMDUtMDVUMjI6NTE6MzcuMjM0MTMwWiJ9"
			"content-type":"image/png"
	]