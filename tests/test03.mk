.PHONY: all all_fasta clean
GILIST=52854274 156118490 290782623 209485592 149126991 254749437 269857780 14971105 256041807 269857713

%.fa: 
	$(description $@,download gi:$(basename $@) from NCBI as fasta)wget -O "$@"  "http://eutils.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi?db=protein&id=$(basename $@)&retmode=text&rettype=fasta"

all: all_fasta
	echo "Done"

all_fasta: longest.fa

longest.fa : all.fa
	$(description $@,get the longest sequence in $<)awk '/^>/ { printf("%s%s\t",(NR==1?"":"\n"),$$0);next;} { printf("%s",$$0);} END {printf("\n");}' $< |\
	awk -F '\t' '{printf("%d\t%s\n",length($$2),$$0);}' | sort -t '	' -k1,1n | tail -n1 | cut -f 2- |\
	tr "\t" "\n" > $@

all.fa : $(addsuffix .fa,${GILIST})
	$(description $@,concatenate everything)cat $^ > $@
	
clean:
	rm -f $(addsuffix .fa,${GILIST}) longest.fa

