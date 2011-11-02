# A simple Makefile for 
#  - pulling stuff from github wiki
#  - converting wiki (Markdown) to LaTeX using pandoc
#  - compiling LaTeX using pdflatex

# COMMANDS:
#   all 	(same as make update; make pdf)
#   pdf 	build pdf with pdflatex
#   update 	update the wiki files from git

# all source files that are generated from wiki
WIKI_DEPS = Introduction.tex


all: update pdf

pdf: main.pdf

main.pdf: main.tex $(WIKI_DEPS)
	pdflatex main
	bibtex main
	pdflatex main
	pdflatex main

clean:
	rm -f main.aux main.log main.bbl main.blg main.dvi main.toc main.pdf

realclean: clean
	rm -rf wiki

update: wiki
	cd wiki
	git pull
	cd ..

wiki:
	git clone git@github.com:dancek/Machine-Learning-project.wiki.git wiki

%.tex: wiki

# get *.tex from wiki/*.md by converting with pandoc
%.tex: wiki/%.md
	pandoc -o $@ $<
