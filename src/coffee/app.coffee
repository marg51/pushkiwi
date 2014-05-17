app = angular.module 'kiwi.pushbullet', [
	'ui.router'
	'ngAnimate'
	'ngMessages'
	'uto.flexbox'
	'templates-prod'
	'ngSanitize'
	'chieffancypants.loadingBar'
]

app.config ($stateProvider, $urlRouterProvider) ->

	$stateProvider.state("login",
		url: "/login"
		templateUrl: "tmpl-login.html"
		controller: "LoginCtrl"
	).state("logout",
		url: "/logout"
		templateUrl: ""
		controller: "LogoutCtrl"
	).state("error",
		url: "/error"
		templateUrl: "tmpl-error.html"
	)

	.state("pushbullet",
		url: "/pushbullet"
		abstract: true
		templateUrl: "tmpl-pushbullet.html"
		controller: "PushbulletCtrl"
		resolve:
			user: (User) ->
				User.getUser()
			ws: (user, pushbulletWsService) ->
				# this fn return true, we don't wait for the socket to be connected
				# therefore, it does not block if the WS server is down
				pushbulletWsService.connect(user)
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

	$urlRouterProvider.otherwise "/pushbullet/list"