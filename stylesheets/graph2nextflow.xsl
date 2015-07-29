<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:x="http://exslt.org/dates-and-times"
	version="1.0"
	>
<!-- convert a xml-make to http://www.nextflow.io/ 

see :

https://twitter.com/PaoloDiTommaso/status/626006490973904896

https://www.biostars.org/p/152226/#152386

-->
<xsl:output method="text"/>
<xsl:key name="tt" match="target" use="@id" />

<xsl:template match="/">
<xsl:apply-templates select="make"/>
</xsl:template>

<xsl:template match="make">
<xsl:text>#!/usr/bin/env nextflow
</xsl:text>
<xsl:apply-templates select="target"/>

</xsl:template>   


<xsl:template match="target">
<xsl:variable name="this" select="."/>
<xsl:variable name="deps" select="/make/target[prerequisites/prerequisite/@ref = $this/@id]"/>


/** <xsl:value-of select="@name"/><xsl:if test="@name != @description"> : <xsl:value-of select="@description"/></xsl:if> */
process <xsl:value-of select="concat('proc',$this/@id)"/>	{
<xsl:if test="/make/@pwd">
	/* http://www.nextflow.io/docs/latest/process.html#storedir */
	storeDir  '<xsl:value-of select="/make/@pwd"/>'
	
	tag { '<xsl:value-of select="@description"/>' }	
	
</xsl:if>
	output:
	file <xsl:apply-templates select="$this" mode="phony-name"/><xsl:for-each select="$deps">
	file <xsl:apply-templates select="$this" mode="phony-name"/> into <xsl:value-of select="concat('proc_',$this/@id,'_to_',@id)"/>
	</xsl:for-each>


<xsl:choose>
<xsl:when test="count(prerequisites/prerequisite)&gt;0">
	input:<xsl:for-each select="prerequisites/prerequisite">
	file <xsl:apply-templates select="key('tt',@ref)" mode="phony-name"/> from <xsl:value-of select="concat('proc_',@ref,'_to_',$this/@id)"/>
	</xsl:for-each>
</xsl:when>
<xsl:when test="count(statements/statement)=0">
	input:
	file '<xsl:value-of select="@name"/>' from file('<xsl:value-of select="@name"/>')
</xsl:when>
</xsl:choose>
	
	'''
	#!<xsl:value-of select="/make/@shell"/>
	<xsl:for-each select="statements/statement"><xsl:text>
	</xsl:text>
	<xsl:value-of select="text()"/>
	</xsl:for-each>
	<xsl:choose>
	<xsl:when test="@phony='1'">
	touch <xsl:apply-templates select="." mode="phony-name"/></xsl:when>
	<xsl:when test="count(statements/statement) = 0">
	touch -c <xsl:apply-templates select="." mode="phony-name"/></xsl:when>
	</xsl:choose>
	'''
	}



</xsl:template>     

<xsl:template match="target" mode="phony-name">
<xsl:text>'</xsl:text>
<xsl:choose>
   <xsl:when test="@phony='1'"><xsl:value-of select="concat('__',@id,'_phony.flag')"/></xsl:when>
   <xsl:otherwise><xsl:value-of select="@name"/></xsl:otherwise>
</xsl:choose>
<xsl:text>'</xsl:text>
</xsl:template>

   
</xsl:stylesheet>
