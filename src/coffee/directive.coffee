app = angular.module 'kiwi.pushbullet'

# http://docs.uto.io/fr.multi-templates-directive.html

app.directive 'pushbullet', ($http, $templateCache, $compile, pushbulletService, require, MyPushes) ->
	templateUrl: 'dir-pushbullet.html'
	scope:
		pushbullet:'='
		ctrl:'='
	link: (scope, elm, attrs) ->
		item = scope.pushbullet
		moment = require('moment')(item.created*1000)
		scope.date_relative = moment.from()
		scope.date = moment.format("dddd, MMMM Do YYYY, h:mm:ss a")
		scope.parent = scope.$parent

		# the notif was sent to a friend ?
		scope.isEmitted = scope.ctrl.user.email isnt item.receiver_email

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


		scope.delete = ->
			MyPushes.delete(scope.pushbullet)

		if item.type is 'list'
			# We update checkbox 
			scope.save = ->
				pushbulletService.query("pushes/#{item.iden}",'POST',items: item.items)

		if item.type is 'address'
			scope.pushbullet.address_link = encodeURI(scope.pushbullet.address)

