.PHONY: all test

%.rna : 
	$(description $@,print a RNA sequence)echo "AUGAAGACUGACUCGAUCGAUCG" > $@


%.dna : %.rna
	tr "U" T" < $< > $@

all  : database.dna test.log 
	$(description $@,this is the main target)echo "done"


test.log: test
	touch $@

test: database.dna log.rna

database.dna : $(addsuffix .rna,$(addprefix seq, 1 2 3  ))
	$(description $@,concatenate everything)cat $^ > $@


clean:
	rm -f *.rna *.dna

