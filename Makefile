install:
	npm install
	bower install
	mkdir -p .nw 
	curl http://dl.node-webkit.org/v0.8.6/node-webkit-v0.8.6-osx-ia32.zip > .nw/nw.zip
	cd .nw && unzip nw.zip
	rm .nw/nw.zip

start:
	grunt
	grunt shell:nwlocal

.PHONY: install start