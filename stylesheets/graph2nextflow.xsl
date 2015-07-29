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


/** <xsl:value-of select="@name"/>  : <xsl:value-of select="@description"/> */
process <xsl:value-of select="concat('proc',$this/@id)"/>	{

<xsl:if test="count($deps)&gt;0">	
	
	output:<xsl:for-each select="$deps">
	file '<xsl:value-of select="$this/@name"/>' into <xsl:value-of select="concat('proc',@id,'_input')"/>
	</xsl:for-each>
	
</xsl:if>

<xsl:if test="count(prerequisites/prerequisite)&gt;0">
	
	input:<xsl:for-each select="prerequisites/prerequisite">
	file  '<xsl:value-of select="@name"/>' from <xsl:value-of select="concat('proc',$this/@id,'_input')"/>
	</xsl:for-each>
</xsl:if>
	
	'''
	#!<xsl:value-of select="/make/@shell"/>
	<xsl:text>
	</xsl:text>
	<xsl:for-each select="statements/statement">
	<xsl:value-of select="text()"/><xsl:text>
	</xsl:text></xsl:for-each>'''
	}



</xsl:template>     
   
</xsl:stylesheet>
