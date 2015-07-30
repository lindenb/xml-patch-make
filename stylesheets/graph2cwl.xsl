<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:x="http://exslt.org/dates-and-times"
	version="1.0"
	>
<!-- convert a xml-make to CWL https://github.com/common-workflow-language -->
<xsl:output method="text"/>
<xsl:param name="base.dir">TMP</xsl:param>
<xsl:key name="tt" match="target" use="@id" />

<!-- pour memoire  : /home/lindenb/.local/bin/cwl-runner -->

<xsl:template match="/">
<xsl:apply-templates select="make"/>
</xsl:template>

<xsl:template match="make">
<xsl:variable name="top" select="target[position() = last()]"/>

<xsl:apply-templates select="target" mode="shell"/>

<xsl:document href="{$base.dir}/make.json" method="text">
{

}
</xsl:document>

<xsl:document href="{$base.dir}/make.cwl" method="text">
<xsl:text>#!/usr/bin/env cwl-runner
</xsl:text>

- id: "#make2cwl"
  class: CommandLineTool
  description: "make2cwl"
  inputs:
  	- id: "#targetid"
  	  description: "make2cwl"
  	  type: int
  	  inputBinding:
  	      position: 1
  outputs:
    - id: "#output"
      type: File
      outputBinding:
        glob:  make2cwl.ok
  baseCommand: make2cwl.sh

- id: "#main"
  class: Workflow
  outputs:
    - id: "#outfile"
      type: File
      source: "<xsl:value-of select="concat($top/@ref,'.ok.flag')"/>"

  steps:
<xsl:for-each select="target">
    <xsl:sort select="position()" data-type="number"/>
	<xsl:apply-templates select="." mode="step"/>
</xsl:for-each>

</xsl:document>
</xsl:template>   


<!--==== TARGET STEP ===================================================== -->
<xsl:template match="target" mode="step">
  - id: "<xsl:value-of select="concat('#step',@id)"/>"
    inputs:<xsl:for-each select="prerequisites/prerequisite">
      - { id: "#targetid", source: "#step<xsl:value-of select="@ref"/>.output" }</xsl:for-each>
    outputs:
      - { id: "<xsl:value-of select="concat('#step',@id,'.output')"/>" }
    run: { import: "#make2cwl" }
<xsl:text>

</xsl:text>
</xsl:template>

<!--==== MAKE SHELL ===================================================== -->
<xsl:template match="make" mode="shell">
<xsl:variable name="path"><xsl:value-of select="$base.dir"/>/make2cwl.sh</xsl:variable>
<xsl:document href="{$path}" method="text">#!<xsl:value-of select="/make/@shell"/>
function die () {
    echo 1&gt;&amp;2 "ERROR: $0 : $@"
    exit 1
}
if [ "$#" -ne 1 ]; then
    die "Illegal number of parameters"
fi

oldpwd=${PWD}


<xsl:apply-templates select="target" mode="shell"/>


case "$1" in<xsl:for-each select="target"><xls:text>
	</xsl:text><xsl:value-of select="@id"/>)
    run<xsl:value-of select="@id"/>
    ;;</xsl:for-each>
	*)
	die "Undefined target id=$1"
	;;
esac

</xsl:template>

<!--==== TARGET SHELL ===================================================== -->

<xsl:template match="target" mode="shell">


function run<xsl:value-of select="@id"/>() {<xsl:if test="/make/@pwd">
	cd '<xsl:value-of select="/make/@pwd"/>'
	</xsl:if>
	<xsl:for-each select="prerequisites/prerequisite">
	if [ ! -f "<xsl:value-of select="@name"/>" ] then;
		die "File <xsl:value-of select="@name"/> missing"
	fi; 
	</xsl:for-each>
	
	<xsl:for-each select="statements/statement"><xsl:text>
		</xsl:text>
	<xsl:value-of select="text()"/>
	</xsl:for-each>
	
	cd "${oldpwd}" &amp;&amp; touch make2cwl.ok
	}

</xsl:template>

<!--==== TARGET SHELL ===================================================== -->

<xsl:template match="target" mode="phony-name">
<xsl:text>"</xsl:text>
<xsl:choose>
   <xsl:when test="@phony='1'"><xsl:value-of select="concat('__',@id,'_phony.flag')"/></xsl:when>
   <xsl:otherwise><xsl:value-of select="@name"/></xsl:otherwise>
</xsl:choose>
<xsl:text>"</xsl:text>
</xsl:template>

   
</xsl:stylesheet>
