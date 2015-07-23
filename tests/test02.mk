.PHONY:


%.rna : 
	echo "AUGAAGACUGACUCGAUCGAUCG" > $@

%.dna : %.rna
	tr "U" T" < $< > $@

all: database.dna


database.dna : $(addsuffix .rna,$(addprefix seq, 1 2 3  ))
	cat $^ > $@

clean:
	rm -f *.rna *.dna

