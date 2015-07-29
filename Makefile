SHELL=/bin/bash
make.version=4.1
testlist=01 02 03
xmake.exe=make-$(make.version)/bin/xml-make$(make.version) 

.PHONY: all clean download-make test _patch test-nextflow

${xmake.exe} : src/xml-make-$(make.version).patch
	rm -rf make-$(make.version)
	mkdir -p make-$(make.version)
	wget -O make-$(make.version).tar.gz "http://ftp.gnu.org/gnu/make/make-$(make.version).tar.gz"
	tar xvfz make-$(make.version).tar.gz -C make-$(make.version)
	cp $< make-$(make.version)/make-$(make.version)/
	cp -r make-$(make.version)/make-$(make.version) make-$(make.version)/original
	rm make-$(make.version).tar.gz
	(cd make-$(make.version)/make-$(make.version) &&  autoreconf && automake && ./configure --prefix=$${PWD}/..  --program-prefix=xml- --program-suffix=$(make.version) && patch   --input=$(notdir $<) --batch && make install)

test: ${xmake.exe} 
	$(foreach T,${testlist}, $< -C tests -f test${T}.mk --xml tests/test${T}.xml ; )
	$(foreach T,${testlist}, xsltproc --output tests/test${T}.make  stylesheets/graph2make.xsl tests/test${T}.xml  ;)
	$(foreach T,${testlist}, xsltproc --output tests/test${T}.gexf stylesheets/graph2gexf.xsl tests/test${T}.xml  ;)
	$(foreach T,${testlist}, xsltproc --output tests/test${T}.md stylesheets/graph2markdown.xsl tests/test${T}.xml  ;)
	$(foreach T,${testlist}, xsltproc --output tests/test${T}.html stylesheets/graph2html.xsl tests/test${T}.xml  ;)
	$(foreach T,${testlist}, xsltproc --output tests/test${T}.nf stylesheets/graph2nextflow.xsl tests/test${T}.xml  ;)
	$(foreach T,${testlist}, xsltproc --output tests/test${T}.snake stylesheets/graph2snake.xsl tests/test${T}.xml  ;)

clean :
	rm -rf make-$(make.version) nextflow ${xmake.exe} 

#
# private target : create a patch from the edited sources
# 
_patch: 
	rm -f tmp.patch
	-$(foreach F,remake.c function.c job.c main.c Makefile.am xml.c xml.h filedef.h file.c, diff  --new-file --text --unified make-$(make.version)/original/$(F) make-$(make.version)/make-$(make.version)/$(F) >> tmp.patch ;)


##
## testing nextflow.io
##
test-nextflow: tests/test03.nf nextflow ${xmake.exe}
	./nextflow run $<

tests/test03.nf: stylesheets/graph2nextflow.xsl
	xsltproc --output $@ $< tests/test03.xml 
	xsltproc --output $@ $< tests/test03.xml 

nextflow:
	rm -rf $@ 
	curl -fSL "get.nextflow.io" | /bin/bash
