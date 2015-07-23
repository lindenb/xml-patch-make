# xml-patch-make
XML patch allowing GNU make to output the workflow as XML

# Compilation

```
make
```

output is a patched version of GNU make 

```
make-4.1/bin/xml-make4.1
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
	cat $^ > $@

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
  <target name="seq1.rna" parent="database.dna" hname="seq1.rna" update-status="none" state="deps_running" builtin="0" precious="0" loaded="0" updating="0" updated="0" is_target="1" cmd_target="0" phony="0">
    <prerequisites>
  </prerequisites>
    <statements>
      <statement>echo "AUGAAGACUGACUCGAUCGAUCG" &gt; seq1.rna</statement>
    </statements>
  </target>
  <target name="seq2.rna" parent="database.dna" hname="seq2.rna" update-status="none" state="deps_running" builtin="0" precious="0" loaded="0" updating="0" updated="0" is_target="1" cmd_target="0" phony="0">
    <prerequisites>
  </prerequisites>
    <statements>
      <statement>echo "AUGAAGACUGACUCGAUCGAUCG" &gt; seq2.rna</statement>
    </statements>
  </target>
  <target name="seq3.rna" parent="database.dna" hname="seq3.rna" update-status="none" state="deps_running" builtin="0" precious="0" loaded="0" updating="0" updated="0" is_target="1" cmd_target="0" phony="0">
    <prerequisites>
  </prerequisites>
    <statements>
      <statement>echo "AUGAAGACUGACUCGAUCGAUCG" &gt; seq3.rna</statement>
    </statements>
  </target>
  <target name="database.dna" parent="all" hname="database.dna" update-status="none" state="deps_running" builtin="0" precious="0" loaded="0" updating="0" updated="0" is_target="1" cmd_target="0" phony="0">
    <prerequisites>
      <prerequisite name="seq1.rna"/>
      <prerequisite name="seq2.rna"/>
      <prerequisite name="seq3.rna"/>
    </prerequisites>
    <statements>
      <statement>cat seq1.rna seq2.rna seq3.rna &gt; database.dna</statement>
    </statements>
  </target>
</make>
```


## Contribute

- Issue Tracker: http://github.com/lindenb/xml-patch-make/issues
- Source Code: http://github.com/lindenb/xml-patch-make

##See also

* 

##History

* 2015 : Creation

## License

The project is licensed under the MIT license.


