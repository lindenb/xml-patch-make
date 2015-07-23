.PHONY: all test


%.rna : 
	echo "AUGAAGACUGACUCGAUCGAUCG" > $@

%.dna : %.rna
	tr "U" T" < $< > $@

all: database.dna test.log 
	echo "done"

test.log: test
	touch $@

test: database.dna log.rna

database.dna : $(addsuffix .rna,$(addprefix seq, 1 2 3  ))
	cat $^ > $@

clean:
	rm -f *.rna *.dna

