<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
<xsl:output method="text"/>
<xsl:template match="/">
<xsl:apply-templates select="make"/>
</xsl:template>

<xsl:template match="make">
SHELL=/bin/bash
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
<xsl:value-of select="text()"/><xsl:text>
</xsl:text>
</xsl:for-each>

</xsl:template>   
   
</xsl:stylesheet>
