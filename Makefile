SHELL := /bin/bash

export TIMESTAMP=$(shell date +"%s")
export pwd=$(shell pwd)

.PHONY: all
all:
	./compile_all.sh

.PHONY: watch
watch:
	./watch.sh

.PHONY:
test:
	shellcheck ./compile.sh
	shellcheck ./compile_all.sh
	make
	test -f ./docs/index.pdf || exit 1
	test -f ./docs/index.html || exit 1
	make clean
	test ! -f ./docs/index.pdf || exit 1
	test ! -f ./docs/index.html || exit 1

.PHONY: clean
clean:
	rm -f docs/*.html
	rm -f docs/*.pdf

.PHONY: docker
docker:
	docker build -t markdown-resume .
	docker run -it  --name "markdown-resume-${TIMESTAMP}" -v "${pwd}/src:/mdr/src" -v "${pwd}/docs:/mdr/docs" markdown-resume

# a convenience tool for overwriting the example CV built from nietaki's private source
.PHONY: nietaki
nietaki:
	cp -f docs/CV_Jacek_Krolikowski_en.pdf .
