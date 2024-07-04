#!/usr/bin/make -f

SITE_REMOTE ?= www/
export SITE_TITLE ?= Dalregementets IF
export SUBTITLE ?=
KEYWORDS_BASE ?= idrott, förening, idrottsförening, falun, dalarna
SITE_RSYNC_OPTS ?= -O -e "ssh -i deploy_key"

.PHONY: help build deploy clean

SRC = src
IMG = data/img
ICO = data/img/icons
PIC = data/img/pictograms
TMPL = templates
#PAGES = $(shell git ls-tree HEAD --name-only -- $(SRC)/*.html 2>/dev/null)
PAGES = $(shell ls -1 -- $(SRC)/*.html 2>/dev/null)
IMAGES = $(shell ls -1 -- $(IMG)/*.png 2>/dev/null)
ICONS = $(shell ls -1 -- $(IMG)/icons/*.png 2>/dev/null)
PICTOGRAMS = $(shell ls -1 -- $(IMG)/pictograms/*.png 2>/dev/null)

help:
	$(info make build|deploy|clean)

build: $(patsubst $(SRC)/%.html,build/%.html,$(PAGES)) \
	$(patsubst $(IMG)/%.png,build/img/%.png,$(IMAGES)) \
	$(patsubst $(ICO)/%.png,build/img/icons/%.png,$(ICONS)) \
	$(patsubst $(PIC)/%.png,build/img/pictograms/%.png,$(PICTOGRAMS)) \
	build/js/calendar.js \
	build/filebrowser-header.html \
	build/filebrowser-footer.html

deploy: build
	rsync -rLvzc $(SITE_RSYNC_OPTS) build/ data/ $(SITE_REMOTE)

clean:
	rm -rf build

build/%.html: $(SRC)/%.html $(SRC)/%.env $(addprefix $(TMPL)/,$(addsuffix .html,header banner footer))
	mkdir -p build
	export $(shell grep -v '^#' $(SRC)/$*.env | tr '\n' '\0' | xargs -0); \
	export KEYWORDS="$(KEYWORDS_BASE), $$KEYWORDS"; \
	[ -z "$$PAGE_TITLE" -o "$*" = "index" ] && TITLE="$(SITE_TITLE)" || TITLE="$$PAGE_TITLE · $(SITE_TITLE)"; \
	export TITLE; \
	[ -z "$$BANNER" ] && cp $(TMPL)/header.html $@.tmp1 || sed -e '/<!-- BANNER -->/{r $(TMPL)/banner.html' -e 'd}' $(TMPL)/header.html > $@.tmp1; \
	envsubst < $@.tmp1 > $@.tmp2; \
	rm $@.tmp1; \
	envsubst < $< >> $@.tmp2; \
	[ -z "$$SIDEIMAGE" ] || sed -i -e '/<!-- SIDEIMAGE -->/{r $(TMPL)/sideimage.html' -e 'd}' $@.tmp2; \
	[ -z "$$PAGETITLE" ] || sed -i -e 's#<!-- PAGETITLE -->#<h1>$$PAGE_TITLE</h1>#' $@.tmp2; \
	envsubst < $@.tmp2 > $@; \
	rm $@.tmp2; \
	envsubst < $(TMPL)/footer.html >> $@; \

build/filebrowser-header.html: $(addprefix $(TMPL)/,$(addsuffix .html,header))
	mkdir -p build
	export PAGE_TITLE="$(SITE_TITLE)"; \
	export TITLE="$(SITE_TITLE)"; \
	export KEYWORDS="$(KEYWORDS_BASE)"; \
	sed -e 's/\[\[ BANNER \]\]//' $(TMPL)/header.html > $@.tmp; \
	sed -i -e '/<!-- EXTRACSS -->/{r $(TMPL)/filebrowser.html' -e 'd}' $@.tmp; \
	sed -i -e 's/id="content"/id="filebrowser"/' $@.tmp; \
	echo "	  <h1>" >> $@.tmp; \
	envsubst < $@.tmp > $@; \
	rm $@.tmp; \

build/filebrowser-footer.html: $(addprefix $(TMPL)/,$(addsuffix .html,footer))
	mkdir -p build
	cp $(TMPL)/footer.html $@; \

build/img/%.png: $(IMG)/%.png
	mkdir -p build/img
	cp $(IMG)/$(@F) $@; \
	sh webp.sh $@; \

build/img/icons/%.png: $(ICO)/%.png
	mkdir -p build/img/icons
	cp $(ICO)/$(@F) $@; \
	sh webp.sh $@; \

build/img/pictograms/%.png: $(PIC)/%.png
	mkdir -p build/img/pictograms
	cp $(PIC)/$(@F) $@; \
	sh webp.sh $@; \

build/js/calendar.js: data/js/buildcalendar.js
	sh calendar.sh; \
