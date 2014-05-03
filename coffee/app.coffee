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
	)

app.config (configFactoryProvider) ->
	pushbullet = configFactoryProvider.create('pushbullet')
	pushbullet
		.add('key')
		.add('email')