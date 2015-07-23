SHELL=/bin/bash
.PHONY: all clean download-make test
make.version=4.1

make-$(make.version)/bin/xml-make$(make.version) : src/xml-make-$(make.version).patch
	rm -rf make-$(make.version)
	mkdir -p make-$(make.version)
	wget -O make-$(make.version).tar.gz "http://ftp.gnu.org/gnu/make/make-$(make.version).tar.gz"
	tar xvfz make-$(make.version).tar.gz -C make-$(make.version)
	cp $< make-$(make.version)/make-$(make.version)/
	cp -r make-$(make.version)/make-$(make.version) make-$(make.version)/original
	rm make-$(make.version).tar.gz
	(cd make-$(make.version)/make-$(make.version) &&  ./configure --prefix=$${PWD}/..  --program-prefix=xml- --program-suffix=$(make.version) && patch   --input=$(notdir $<) --batch && make install)

test: make-$(make.version)/bin/xml-make$(make.version)
	$< -C tests -f test01.mk --xml tests/test01.xml all clean
	$< -C tests -f test02.mk --xml tests/test02.xml all clean

clean :
	rm -rf make-$(make.version)
