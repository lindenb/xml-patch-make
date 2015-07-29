# xml-patch-make

patch allowing GNU make to output the workflow as XML


# Compilation

```
make
```

output is a patched version of GNU make 

```
make-4.1/bin/xml-make4.1
```


# Usage

```
make-4.1/bin/xml-make4.1 -f mymakefile.mk -B --xml out.xml targetname
```

# Example

A simple makefile:

```make
.PHONY:


%.rna : 
	echo "AUGAAGACUGACUCGAUCGAUCG" > $@

%.dna : %.rna
	tr "U" T" < $< > $@

all: database.dna


database.dna : $(addsuffix .rna,$(addprefix seq, 1 2 3  ))
	$(description $@,concatenate all)cat $^ > $@

clean:
	rm -f *.rna *.dna
```

invoke
 
```
make-4.1/bin/xml-make4.1  --xml output.xml
```

content of output.xml

```xml
<?xml version="1.0" encoding="UTF-8"?>
<make>
<target name="seq1.rna" description="seq1.rna" id="1" precious="0" phony="0">
  <statements>
    <statement>echo &quot;AUGAAGACUGACUCGAUCGAUCG&quot; &gt; seq1.rna</statement>
  </statements>
</target>
<target name="seq2.rna" description="seq2.rna" id="2" precious="0" phony="0">
  <statements>
    <statement>echo &quot;AUGAAGACUGACUCGAUCGAUCG&quot; &gt; seq2.rna</statement>
  </statements>
</target>
<target name="seq3.rna" description="seq3.rna" id="3" precious="0" phony="0">
  <statements>
    <statement>echo &quot;AUGAAGACUGACUCGAUCGAUCG&quot; &gt; seq3.rna</statement>
  </statements>
</target>
<target name="database.dna" description="concatenate all" id="4" precious="0" phony="0">
  <prerequisites>
    <prerequisite name="seq1.rna" ref="1"/>
    <prerequisite name="seq2.rna" ref="2"/>
    <prerequisite name="seq3.rna" ref="3"/>
  </prerequisites>
  <statements>
    <statement>cat seq1.rna seq2.rna seq3.rna &gt; database.dna</statement>
  </statements>
</target>
<target name="log.rna" description="log.rna" id="5" precious="0" phony="0">
  <statements>
    <statement>echo &quot;AUGAAGACUGACUCGAUCGAUCG&quot; &gt; log.rna</statement>
  </statements>
</target>
<target name="test.log" description="test.log" id="6" precious="0" phony="0">
  <prerequisites>
    <prerequisite name="test" ref="7"/>
  </prerequisites>
  <statements>
    <statement>touch test.log</statement>
  </statements>
</target>
<target name="test" description="test" id="7" precious="0" phony="1">
</target>
<target name="all" description="all" id="8" precious="0" phony="1">
  <prerequisites>
    <prerequisite name="database.dna" ref="4"/>
    <prerequisite name="test.log" ref="6"/>
  </prerequisites>
  <statements>
    <statement>echo &quot;done&quot;</statement>
  </statements>
</target>
</make>
```

## XSL stylesheets

the folder **stylesheets** contains XSLT stylesheets to convert the XML:

*  graph2dot  to Graphviz/Dot
*  graph2html to HTML
*  graph2make to Makefile
*  graph2gex  to GEXF
*  graph2markdown to Markdown
*  graph2snake to Snakemake see https://github.com/lindenb/xml-patch-make/wiki/SnakeMake
*  graph2nextflow to nextflow.io see https://github.com/lindenb/xml-patch-make/wiki/Tabix

## $(description target,desc)

the Patch introduces a new Make function

```make
$(description target,desc)
```

it can be used anywhere

```make
all:
	$(description $@,just print hello)echo "Hello"
```

The new function is used to fill the attribute @description in the XML. It should be ignored by the original Make.

# $(n-core target,integer) $(n-proc target,integer)

` $(n-core target,integer)` and `$(n-proc target,integer)` are two new function used to specifiy the number of core/proc for each target.

e.g:

```make
all  : database.dna test.log 
	$(description $@,this is the main target)$(n-proc $@,1)$(n-core $@,1)echo "done"
```

output:

```xml
  <target name="all" description="this is the main target" id="8" precious="0" phony="1" core="1" proc="1">
    <prerequisites>
      <prerequisite name="database.dna" ref="4"/>
      <prerequisite name="test.log" ref="6"/>
    </prerequisites>
    <statements>
      <statement>echo "done"</statement>
    </statements>
  </target>
```



## Contribute

- Issue Tracker: http://github.com/lindenb/xml-patch-make/issues
- Source Code: http://github.com/lindenb/xml-patch-make

##See also

* https://github.com/lindenb/makefile2graph

##History

* 2015 : Creation

## License

The project is licensed under the MIT license.


