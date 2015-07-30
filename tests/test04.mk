.PHONY:all

all: count.txt

count.txt : test04.mk
	echo -n "Lines: " > $@
	wc -l $< >> $@
