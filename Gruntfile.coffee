module.exports = (grunt) ->
	grunt.loadNpmTasks "grunt-karma"
	grunt.loadNpmTasks "grunt-contrib-coffee"
	grunt.loadNpmTasks "grunt-contrib-clean"
	grunt.loadNpmTasks "grunt-contrib-jade"
	grunt.loadNpmTasks "grunt-contrib-less"
	grunt.loadNpmTasks "grunt-contrib-concat"
	grunt.loadNpmTasks "grunt-contrib-uglify"
	grunt.loadNpmTasks "grunt-ngmin"
	grunt.loadNpmTasks "grunt-html2js"
	grunt.loadNpmTasks "grunt-node-webkit-builder"
	grunt.loadNpmTasks "grunt-shell-spawn"

	grunt.initConfig
		pkg: grunt.file.readJSON('package.json'),

		shell:
			nw:
				command: '/Applications/node-webkit-v8.app/Contents/MacOS/node-webkit .'
				options:
					stdout: true
					async: true
			nwlast:
				command: '/Applications/node-webkit.app/Contents/MacOS/node-webkit .'
				options:
					stdout: true
					async: true
			buildnw:
				command: "zip -r builds/<%= pkg.name %>.nw node_modules/ public/ package.json"
				options:
					stdout: false
			icons:
				command: 'cd bower_components/fontawesome/less && sed -i "" -e "/@fa-font-path:/s/..\\///" variables.less && lessc --clean-css --no-ie-compat font-awesome.less ../../../.build/fa.css && mkdir -p ../../../public/fonts && cp ../fonts/* ../../../public/fonts'

		
		coffee:
			dev: 
				options:
					join: false
					sourceMap: true
				files:
					'./public/app.js': ['src/coffee/*.coffee','src/bundles/**/coffee/*.coffee']
			prod: 
				files:
					'./public/app.js': ['src/coffee/*.coffee','src/bundles/**/coffee/*.coffee']
		jade: 
			dev: 
				options: 
					pretty: true
				files: [{
					expand: true,
					cwd: 'src/jade/'
					src: ['*.jade','!layout.jade','!index.jade']
					dest: '.build/'
					ext: '.html'
				},{
					expand: true,
					cwd: 'src/jade/'
					src: ['index.jade']
					dest: 'public/'
					ext: '.html'
				},{
					expand: true,
					cwd: 'src/bundles/'
					src: ['**/jade/*.jade']
					dest: '.build/'
					ext: '.html'
				}]
			prod: 
				files: [{
					expand: true,
					cwd: 'src/jade/'
					src: ['*.jade','!layout.jade','!index.jade']
					dest: '.build/'
					ext: '.html'
				},{
					expand: true,
					cwd: 'src/jade/'
					src: ['index.jade']
					dest: 'public/'
					ext: '.html'
				},{
					expand: true,
					cwd: 'src/bundles/'
					src: ['**/jade/*.jade']
					dest: '.build/'
					ext: '.html'
				}]

		less:
			dev:
				options:
					sourceMap: true
				files:
					'./public/app.css': ['src/less/*.less','src/bundles/**/less/*.less']
			prod:
				options:
					cleancss: true
				files:
					'./public/app.css': ['src/less/*.less','src/bundles/**/less/*.less']

		clean: 
			public: ['public']
			build: ['.build']

		concat:
			prod:
				options:
					separator: ";"

				dest: "public/deps.js"
				src: [
					"bower_components/angular/angular.js"
					"bower_components/angular-animate/angular-animate.min.js"
					"bower_components/angular-sanitize/angular-sanitize.min.js"
					"bower_components/angular-ui-router/release/angular-ui-router.min.js"
					"bower_components/angular-webkit-require/dist/app.js"
					"bower_components/flex/dist/ng-flexbox.js"
				]

		uglify:
			banner: "/* ©Laurent Margirier */"
			prod:
				files: [
					{
						dest: "public/app.js"
						src: ["public/app.js"]
					}
				]
		html2js:
			options:
				base: ".build/"
				rename: (moduleName) ->
					r=moduleName.split('/')
					r[r.length-1]

			prod:

				src: [".build/*.html",".build/**/jade/*.html"]
				dest: "public/templates.js"

		ngmin:
			prod:
				src: ["public/app.js"]
				dest: "public/app.js"

		watch: 
			src:
				files: ['src/**/*']
				tasks: ['default']

		karma:
			unit:
				configFile: "./tests/karma-unit.conf.js"
				autoWatch: false
				singleRun: true

		nodewebkit:
			options:
				build_dir: './webkitbuilds',
				mac: true
				win: true
				linux32: false
				linux64: false
			src: ['./public/*','package.json']

	grunt.registerTask 'default', ['clean:public','concat:prod','coffee:dev','jade:dev','shell:icons','less:dev','html2js:prod','clean:build']
	grunt.registerTask 'prod', ['clean:public','concat:prod','coffee:prod','jade:prod','shell:icons','less:prod','html2js:prod','ngmin:prod','clean:build']
	
	grunt.registerTask 'watch', ['default','watch:src']
	grunt.registerTask 'w', ['watch']
	grunt.registerTask 'launch', ['default','shell:nw']
	grunt.registerTask "test:unit", [
		"karma:unit"
	]
