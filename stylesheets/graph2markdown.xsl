<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	version="1.0"
	xmlns:x="http://exslt.org/dates-and-times"
	>
<xsl:output method="text"/>
<xsl:key name="tt" match="target" use="@id" />

<xsl:template match="/">
<xsl:apply-templates select="make"/>
</xsl:template>

<xsl:template match="make">
#Makefile graph

##All targets

<xsl:for-each select="target">
 		 <xsl:sort select="@name"/>
 		<xsl:apply-templates select="." mode="anchor"/>
 		<xsl:text> </xsl:text>
 </xsl:for-each>

##Targets

<xsl:apply-templates select="target">
        <xsl:sort select="position()" data-type="number" order="descending"/>
</xsl:apply-templates>

-- 

Generated with https://github.com/lindenb/xml-patch-make. Author: Pierre Lindenbaum [@yokofakun](https://twitter.com) Date: <xsl:if test="function-available('x:date-time')"><xsl:value-of select="x:date-time()"/></xsl:if>.

</xsl:template>
   
   
<xsl:template match="target">
<xsl:variable name="myid" select="@id"/>
###&lt;a name="<xsl:value-of select="$myid"/>"&gt;&lt;/a&gt;<xsl:value-of select="@name"/>
<xsl:if test="count(prerequisites/prerequisite)&gt;0">
**prerequisites** : <xsl:for-each select="prerequisites/prerequisite">
	<xsl:text>[</xsl:text>
	<xsl:value-of select="@name"/>
	<xsl:text>](#</xsl:text>
	<xsl:value-of select="@ref"/>
	<xsl:text>) </xsl:text>
</xsl:for-each>

</xsl:if>

<xsl:if test="/make/target[prerequisites/prerequisite/@ref = $myid]">

**Used by** :  <xsl:for-each select="/make/target[prerequisites/prerequisite/@ref = $myid]">
	<xsl:apply-templates select="." mode="anchor"/>
	<xsl:text> </xsl:text>
</xsl:for-each>

</xsl:if>
<xsl:if test="count(statements/statement)&gt;0">

```bash
<xsl:for-each select="statements/statement">
<xsl:value-of select="text()"/><xsl:text>
</xsl:text>
</xsl:for-each><xsl:text>```</xsl:text>
</xsl:if>
<xsl:text>
</xsl:text>
</xsl:template>

<xsl:template match="target" mode="anchor">
<xsl:text>[</xsl:text>
<xsl:value-of select="@name"/>
<xsl:text>](#</xsl:text>
<xsl:value-of select="@id"/>
<xsl:text>)</xsl:text>
</xsl:template>

</xsl:stylesheet>
