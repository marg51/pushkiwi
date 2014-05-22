# Access pushbullet from outside the application
# Only on Node.JS

app = angular.module 'kiwi.pushbullet'

app.provider 'bridgeService', ->
	provider = {}

	provider.PORT = 5468



	provider.$get= ($state) ->
		return if not require

		http = require('restify')
		Window = require('nw.gui').Window.get()

		server = http.createServer
			name:'Bridge'
			version: '0.0.1'

		server.use http.acceptParser(server.acceptable)
		server.use http.queryParser()
		server.use http.bodyParser()
		server.listen provider.PORT
		
		lastData = {}

		server.post 'add/:type', (req, res, next) ->
			lastData = req.params
			$state.go("pushbullet.add.#{req.params.type}",req.params,reload:true)
			Window.show()
			res.send({status:'success'})

		getData: ->
			# return lastData and reinitialise its value
			[t,lastData] = [lastData, {}]
			return t

	provider
