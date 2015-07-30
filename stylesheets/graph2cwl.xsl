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

<xsl:for-each select="target">
 <xsl:sort select="position()" data-type="number" order="descending"/>
	<xsl:apply-templates select="." mode="cmd"/>
</xsl:for-each>

- id: "#main"
  class: Workflow
  outputs:
    - id: "#outfile"
      type: File
      source: "#combine_sequences.catout"

  requirements:
    - class: ScatterFeatureRequirement

  steps:
<xsl:for-each select="target">
    <xsl:sort select="position()" data-type="number"/>
	<xsl:apply-templates select="." mode="step"/>
</xsl:for-each>

</xsl:document>
</xsl:template>   


<xsl:template match="target" mode="cmd">

- id: "<xsl:value-of select="concat('#cmd',@id)"/>"
  class: CommandLineTool
  description: "<xsl:value-of select="@name"/>"
  inputs:<xsl:for-each select="prerequisites/prerequisite">
  	- id: "<xsl:value-of select="concat('#slot',@ref)"/>"
  	  description: "<xsl:value-of select="@name"/>"
  	  type: File
  	  inputBinding:
  	      position: <xsl:value-of select="position()"/>
  	</xsl:for-each>
  outputs:
    - id: "#output"
      type: File
      outputBinding:
        glob:  <xsl:apply-templates select="." mode="phony-name"/>
  baseCommand: <xsl:value-of select="concat('proc',@id,'.sh')"/>

<xsl:text>

</xsl:text>
</xsl:template>

<xsl:template match="target" mode="step">
  - id: "<xsl:value-of select="concat('#step',@id)"/>"
    inputs:<xsl:for-each select="prerequisites/prerequisite">
      - { id: "<xsl:value-of select="concat('#step',@ref)"/>", source: "<xsl:value-of select="concat('#cmd',@ref)"/>.output" }</xsl:for-each>
    outputs:
      - { id: "<xsl:value-of select="concat('#step',@id,'.output')"/>" }
    run: { import: "<xsl:value-of select="concat('#cmd',@id)"/>" }
<xsl:text>

</xsl:text>
</xsl:template>



<xsl:template match="target" mode="shell">
<xsl:variable name="path"><xsl:value-of select="$base.dir"/>/proc<xsl:value-of select="@id"/>.sh</xsl:variable>
<xsl:document href="{$path}" method="text">#!<xsl:value-of select="/make/@shell"/>
oldpwd=${PWD}

set -e
set -u


function run<xsl:value-of select="@id"/>() {<xsl:if test="/make/@pwd">
	cd '<xsl:value-of select="/make/@pwd"/>'
	</xsl:if>
	<xsl:for-each select="prerequisites/prerequisite">
	if [ ! -f "<xsl:value-of select="@name"/>" ] then;
		echo "File <xsl:value-of select="@name"/> : missing" 1&gt;&amp;2 &amp;&amp; exit 1
	fi; 
	</xsl:for-each>
	
	<xsl:for-each select="statements/statement"><xsl:text>
		</xsl:text>
	<xsl:value-of select="text()"/>
	</xsl:for-each>
	}

run<xsl:value-of select="@id"/> &amp;&amp; cd "${oldpwd}" &amp;&amp; touch <xsl:value-of select="concat(@id,'.ok.flag')"/>

</xsl:document>
</xsl:template>

<xsl:template match="target" mode="phony-name">
<xsl:text>"</xsl:text>
<xsl:choose>
   <xsl:when test="@phony='1'"><xsl:value-of select="concat('__',@id,'_phony.flag')"/></xsl:when>
   <xsl:otherwise><xsl:value-of select="@name"/></xsl:otherwise>
</xsl:choose>
<xsl:text>"</xsl:text>
</xsl:template>

   
</xsl:stylesheet>
