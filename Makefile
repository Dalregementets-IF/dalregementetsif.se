#!/usr/bin/make -f

SITE_REMOTE ?= www/
export SITE_TITLE ?= Dalregementets IF
export SUBTITLE ?=
KEYWORDS_BASE ?= idrott, förening, idrottsförening, falun, dalarna
SITE_RSYNC_OPTS ?= -O -e "ssh -i deploy_key"

.PHONY: help build deploy clean

SRC = src
IMG = data/img
export TMPL = templates
#PAGES = $(shell git ls-tree HEAD --name-only -- $(SRC)/*.html 2>/dev/null)
PAGES = $(shell ls -1 -- $(SRC)/*.txt 2>/dev/null)

help:
	$(info make build|deploy|clean)

build: $(patsubst $(SRC)/%.txt,build/%.html,$(PAGES)) \
	build/editor.html \
	build/img \
	build/js/calendar.js \
	build/filebrowser-header.html \
	build/filebrowser-footer.html

deploy: build
	rsync -rLvzc $(SITE_RSYNC_OPTS) build/ data/ $(SITE_REMOTE)

clean:
	rm -rf build

build/%.html: $(SRC)/%.txt $(addprefix $(TMPL)/,$(addsuffix .html,header banner footer))
	sh build.sh "$(SRC)/$(*).txt" "$(@)"

build/filebrowser-header.html: $(addprefix $(TMPL)/,$(addsuffix .html,header))
	mkdir -p build
	export PAGE_TITLE="$(SITE_TITLE)"; \
	export TITLE="$(SITE_TITLE)"; \
	export KEYWORDS="$(KEYWORDS_BASE)"; \
	sed -e '/<!-- BANNER -->/d' $(TMPL)/header.html > $@.tmp; \
	sed -i -e '/<h1>$$PAGE_TITLE<\/h1>/d' $@.tmp; \
	sed -i -e '/<!-- EXTRACSS -->/{r $(TMPL)/filebrowser.html' -e 'd}' $@.tmp; \
	sed -i -e 's/id="content"/id="filebrowser"/' $@.tmp; \
	echo "	  <h1>" >> $@.tmp; \
	envsubst < $@.tmp > $@; \
	rm $@.tmp

build/filebrowser-footer.html: $(addprefix $(TMPL)/,$(addsuffix .html,footer))
	mkdir -p build
	cp $(TMPL)/footer.html $@

build/editor.html: $(SRC)/editor.html $(SRC)/editor.md $(addprefix $(TMPL)/,$(addsuffix .html,header banner footer))
	mkdir -p build
	export PAGE_TITLE="Förhandsgranskning"; \
	export TITLE="$(SITE_TITLE)"; \
	export KEYWORDS="$(KEYWORDS_BASE)"; \
	tail -n+22 $(TMPL)/header.html > $@-head.tmp; \
	head -n-1 $(TMPL)/footer.html > $@-foot.tmp; \
	sed -i -e 's/a href=".*"/a href="#"/' $@-head.tmp; \
	sed -i -e 's/a href=".*"/a href="#"/' $@-foot.tmp; \
	sed -e '/<!-- HEADER -->/{r $@-head.tmp' -e 'd}' $(SRC)/editor.html > $@.tmp; \
	sed -i -e '/<!-- MARKDOWN -->/{r$(SRC)/editor.md' -e 'd}' $@.tmp; \
	sed -i -e '/<!-- FOOTER -->/{r $@-foot.tmp' -e 'd}' $@.tmp; \
	envsubst < $@.tmp > $@; \
	rm $@.tmp $@-head.tmp $@-foot.tmp

build/img:
	sh img.sh $(IMG)

build/js/calendar.js: data/js/buildcalendar.js
	sh calendar.sh
