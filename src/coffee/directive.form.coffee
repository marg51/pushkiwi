app = angular.module 'kiwi.pushbullet'

app.directive "fileread", ->
	scope: 
		fileread: "="
	link: (scope, element, attributes) ->
		element.bind "change", (changeEvent) ->
			scope.fileread = angular.copy changeEvent.target.files[0]
			scope.$apply()

LINK_REGEX = /:\/\//
app.directive 'xlink', ->
	restrict: 'A'
	require: 'ngModel'
	link: (scope, elm, attrs, ctrl) ->
		ctrl.$parsers.unshift (val) -> 
			if LINK_REGEX.test val
				ctrl.$setValidity 'link', true
				return val.trim()
			else
				ctrl.$setValidity 'link', false
				return undefined


TYPE_REGEX = /^[a-z]+\/[a-z0-9]+$/
app.directive 'xtype', ->
	restrict: 'A'
	require: 'ngModel'
	link: (scope, elm, attrs, ctrl) ->
		ctrl.$parsers.unshift (val) -> 
			if TYPE_REGEX.test val
				ctrl.$setValidity 'type', true
				return val.trim()
			else
				ctrl.$setValidity 'type', false
				return undefined
