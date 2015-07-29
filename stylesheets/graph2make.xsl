<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:x="http://exslt.org/dates-and-times"
	version="1.0"
	>
<xsl:output method="text"/>
<xsl:template match="/">
<xsl:apply-templates select="make"/>
</xsl:template>

<xsl:template match="make">
#
# Generated with https://github.com/lindenb/xml-patch-make
# Author : Pierre Lindenbaum @yokofakun
# Date:  <xsl:if test="function-available('x:date-time')"><xsl:value-of select="x:date-time()"/></xsl:if>
#
<xsl:if test="@shell">
<xsl:text>SHELL=</xsl:text>
<xsl:value-of select="@shell"/>
<xsl:text>
</xsl:text>
</xsl:if>

<xsl:if test="@shellflags">
<xsl:text>.SHELLFLAGS=</xsl:text>
<xsl:value-of select="@shellflags"/>
<xsl:text>
</xsl:text>
</xsl:if>

.PHONY: <xsl:for-each select="target[@phony='1']">
		<xsl:text> </xsl:text>
		<xsl:value-of select="@name"/>
	</xsl:for-each>
 <xsl:apply-templates select="target">
        <xsl:sort select="position()" data-type="number" order="descending"/>
  </xsl:apply-templates>
</xsl:template>
  

   
<xsl:template match="target">
<xsl:text>
</xsl:text>
<xsl:value-of select="@name"/>
<xsl:text> : </xsl:text>
<xsl:for-each select="prerequisites/prerequisite">
<xsl:text> </xsl:text>
<xsl:value-of select="@name"/>
</xsl:for-each>
<xsl:text>
</xsl:text>

<xsl:for-each select="statements/statement">
    <xsl:text>	</xsl:text>
    <xsl:call-template name="escape">
        <xsl:with-param name="s" select="text()"/>
    </xsl:call-template>
    <xsl:text>
</xsl:text>
</xsl:for-each>

</xsl:template> 

<xsl:template name="escape">
<xsl:param name="s"/>
<xsl:choose>
  <xsl:when test="contains($s,'$')">
    <xsl:value-of select="substring-before($s,'$')"/>
    <xsl:text>$$</xsl:text>
    <xsl:call-template name="escape">
        <xsl:with-param name="s" select="substring-after($s,'$')"/>
    </xsl:call-template>
  </xsl:when>
  <xsl:otherwise>
    <xsl:value-of select="$s"/>
  </xsl:otherwise>
</xsl:choose>
</xsl:template>
   
</xsl:stylesheet>
