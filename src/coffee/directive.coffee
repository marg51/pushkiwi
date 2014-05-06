app = angular.module 'kiwi.pushbullet'

moment = require('moment')

# http://docs.uto.io/fr.multi-templates-directive.html

app.directive 'pushbullet', ($http, $templateCache, $compile, pushbulletService) ->
	templateUrl: 'dir-pushbullet.html'
	scope:
		pushbullet:'='
		ctrl:'='
	link: (scope, elm, attrs) ->
		item = scope.pushbullet
		scope.date = moment(item.created*1000).from()
		scope.parent = scope.$parent
		scope.isEmitted = scope.ctrl.user.email isnt scope.pushbullet.receiver_email

		if item.type is 'file' and item.file_type.match /^image\//
				template = 'file-image' 
		else 
			template = item.type

		templateUrl = "dir-pushbullet-#{template}.html"

		element = angular.element(elm[0].querySelector('.body'))
		$http.get(templateUrl, {cache: $templateCache}).success((html)->
			element.html(html)
			$compile(element.contents())(scope)
		).error ->
			element.html("<span class='color-red'>item <u>#{template}</u> unknown</span>")

		if item.type is 'list'
			scope.save = ->
				pushbulletService.query("pushes/#{item.iden}",'POST',items: item.items)

		if item.type is 'address'
			scope.pushbullet.address_link = encodeURI(scope.pushbullet.address)

