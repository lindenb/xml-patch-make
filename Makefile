SHELL=/bin/bash
make.version=4.1
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
	$< -C tests -f test01.mk --xml tests/test01.xml all 
	$< -C tests -f test02.mk --xml tests/test02.xml all 

clean :
	rm -rf make-$(make.version) nextflow ${xmake.exe} 

#
# private target : create a patch from the edited sources
# 
_patch: 
	rm -f tmp.patch
	-$(foreach F,function.c job.c main.c Makefile.am xml.c xml.h filedef.h file.c, diff  --new-file --text --unified make-$(make.version)/original/$(F) make-$(make.version)/make-$(make.version)/$(F) >> tmp.patch ;)


##
## testing nextflow.io
##
test-nextflow: tests/test02.nf nextflow ${xmake.exe}
	./nextflow run $<

tests/test02.nf: stylesheets/graph2nextflow.xsl
	xsltproc --output $@ $< tests/test02.xml 

nextflow:
	rm -rf $@ 
	curl -fSL "get.nextflow.io" | /bin/bash
