app = angular.module 'kiwi.pushbullet', ['ngSanitize']

app.config ($stateProvider, $urlRouterProvider) ->
	$stateProvider.state("pushbullet",
		url: "/pushbullet"
		templateUrl: "tmpl-pushbullet.html"
		controller: "PushbulletCtrl"
		resolve:
			ws: (pushbulletWsService) ->
				pushbulletWsService.connect()
	).state("pushbullet.list",
		url: "/list"
		templateUrl: "tmpl-pushbullet-list.html"
		controller: "PushbulletListCtrl"
	).state("pushbullet.add",
		abstract: true
		url: "/add"
		templateUrl: "tmpl-pushbullet-add.html"
		controller: "PushbulletAddCtrl"
	).state("pushbullet.add.note",
		url: "/note"
		templateUrl: "tmpl-pushbullet-add-note.html"
		controller: "PushbulletAddItemCtrl"
	).state("pushbullet.add.link",
		url: "/link"
		templateUrl: "tmpl-pushbullet-add-link.html"
		controller: "PushbulletAddItemCtrl"
	).state("pushbullet.add.file",
		url: "/file"
		templateUrl: "tmpl-pushbullet-add-file.html"
		controller: "PushbulletAddItemCtrl"
	).state("pushbullet.add.address",
		url: "/address"
		templateUrl: "tmpl-pushbullet-add-address.html"
		controller: "PushbulletAddItemCtrl"
	).state("pushbullet.add.list",
		url: "/list"
		templateUrl: "tmpl-pushbullet-add-list.html"
		controller: "PushbulletAddItemCtrl"
	)

app.config (configFactoryProvider) ->
	pushbullet = configFactoryProvider.create('pushbullet')
	pushbullet
		.add('key')
		.add('email')