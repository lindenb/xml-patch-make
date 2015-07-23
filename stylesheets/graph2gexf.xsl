<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	version="1.0"
	xmlns="http://www.gexf.net/1.2draft"
	>
<xsl:output method="xml" indent="yes" encoding="UTF-8"/>

<xsl:template match="/">
<xsl:apply-templates select="make"/>
</xsl:template>

<xsl:template match="make">
<gexf  version="1.2" xmlns="http://www.gexf.net/1.2draft">
   <meta>
     <creator>Pierre Lindenbaum</creator>
     <description>xml-patch-make</description>
   </meta>
    <graph mode="static" defaultedgetype="directed">
		<nodes>
			<xsl:apply-templates select="target" mode="node"/>
		</nodes>
		<edges>
			<xsl:apply-templates select="target" mode="edge"/>
		</edges>
    </graph>
</gexf>
</xsl:template>
   
   
<xsl:template match="target" mode="node">
<node>
	<xsl:attribute name="id"><xsl:value-of select="@id"/></xsl:attribute>
	<xsl:attribute name="label"><xsl:value-of select="@name"/></xsl:attribute>
</node>
</xsl:template>

<xsl:template match="target" mode="edge">
<xsl:variable name="nodeid" select="@id"/>
	<xsl:for-each select="prerequisites/prerequisite">
		<edge>
			<xsl:attribute name="id"><xsl:value-of select="concat($nodeid,'_',@ref)"/></xsl:attribute>
			<xsl:attribute name="target"><xsl:value-of select="$nodeid"/></xsl:attribute>
			<xsl:attribute name="source"><xsl:value-of select="@ref"/></xsl:attribute>
		</edge>
	</xsl:for-each>
</xsl:template>
   
</xsl:stylesheet>
