# Licensed under the Apache License. See footer for details.

.PHONY: vendor

BROWSERIFY = node_modules/.bin/browserify
COFFEE     = node_modules/.bin/coffee
COFFEEC    = $(COFFEE) --bare --compile

#-------------------------------------------------------------------------------
help:
	@echo "available targets:"
	@echo "   watch         - watch for changes, then build, then serve"
	@echo "   build         - build the server"
	@echo "   clean         - erase built files"
	@echo "   vendor        - get vendor files"
	@echo "   help          - print this help"
	@echo ""
	@echo "You will need to run 'make vendor' before duing anything useful."

#-------------------------------------------------------------------------------
clean-all: clean
	-rm -rf vendor/* node_modules/* node_modules/.bin

#-------------------------------------------------------------------------------
watch:
	make build
	@wr "make build" tools scripts

#-------------------------------------------------------------------------------
build:
	@-rm  ogre-pa.js

	@mkdir -p tmp/scripts
	@rm   -rf tmp/scripts/*

	@echo "compiling coffee files"
	@$(COFFEEC) --output tmp/scripts scripts/*.coffee 

	@echo "browserifying"
	@$(BROWSERIFY) \
		--debug \
		--outfile ogre-pa.js \
		tmp/scripts/main.js

	@$(COFFEE) tools/split-sourcemap-data-url.coffee ogre-pa.js

#-------------------------------------------------------------------------------
vendor: 
	npm install

	@-rm  -rf vendor/*
	@mkdir -p vendor

	bower install bootstrap#2.3.x
	bower install font-awesome#3.2.x

	cp bower_components/jquery/jquery.js vendor

	mkdir vendor/bootstrap
	mkdir vendor/bootstrap/css
	mkdir vendor/bootstrap/img
	mkdir vendor/bootstrap/js

	cp bower_components/bootstrap/docs/assets/css/bootstrap*.css   vendor/bootstrap/css
	cp bower_components/bootstrap/docs/assets/img/glyphicons-*.png vendor/bootstrap/img
	cp bower_components/bootstrap/docs/assets/js/bootstrap.js      vendor/bootstrap/js

	mkdir vendor/font-awesome
	mkdir vendor/font-awesome/css
	mkdir vendor/font-awesome/font

	cp bower_components/font-awesome/css/font-awesome-ie7.css vendor/font-awesome/css
	cp bower_components/font-awesome/css/font-awesome.css     vendor/font-awesome/css
	cp bower_components/font-awesome/font/*                   vendor/font-awesome/font

	rm -R bower_components

#-------------------------------------------------------------------------------
icons:
	@echo converting icons with ImageMagick

	@convert -resize 032x032 vassal/images/ogre-mk5-b.png images/icon-032.png
	@convert -resize 057x057 vassal/images/ogre-mk5-b.png images/icon-057.png
	@convert -resize 064x064 vassal/images/ogre-mk5-b.png images/icon-064.png
	@convert -resize 072x072 vassal/images/ogre-mk5-b.png images/icon-072.png
	@convert -resize 096x096 vassal/images/ogre-mk5-b.png images/icon-096.png
	@convert -resize 114x114 vassal/images/ogre-mk5-b.png images/icon-114.png
	@convert -resize 128x128 vassal/images/ogre-mk5-b.png images/icon-128.png
	@convert -resize 144x144 vassal/images/ogre-mk5-b.png images/icon-144.png
	@convert -resize 256x256 vassal/images/ogre-mk5-b.png images/icon-256.png

#-------------------------------------------------------------------------------
# Copyright 2013 Patrick Mueller
# 
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# 
#    http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#-------------------------------------------------------------------------------

