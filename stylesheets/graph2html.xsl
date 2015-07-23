<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
<xsl:output method="html"/>
<xsl:key name="tt" match="target" use="@id" />

<xsl:template match="/">
<xsl:apply-templates select="make"/>
</xsl:template>

<xsl:template match="make">
<html>
 <head>
 	<title>Makefile graph</title>
 </head>
 <body>
 	<h1>Makefile graph</h1>
 	<div>
 <xsl:apply-templates select="target">
        <xsl:sort select="position()" data-type="number" order="descending"/>
  </xsl:apply-templates>
   </div>
 </body>
</html>
</xsl:template>
   
   
<xsl:template match="target">
<xsl:variable name="myid" select="@id"/>
<a>
 <xsl:attribute name="name"><xsl:value-of select="$myid"/></xsl:attribute>
</a>
<h2><xsl:value-of select="@name"/></h2>
<xsl:if test="count(prerequisites/prerequisite)&gt;0">
<h3>prerequisites</h3>
<ul>
<xsl:for-each select="prerequisites/prerequisite">
 <li>
    <a><xsl:attribute name="href"><xsl:value-of select="concat('#',@ref)"/></xsl:attribute>
    	<xsl:value-of select="@name"/>
    </a>
 </li>
</xsl:for-each>
</ul>
</xsl:if>

<h3>Used</h3>
<ul>
<xsl:for-each select="/make/target[prerequisites/prerequisite/@ref = $myid]">
	<li>
		<a><xsl:attribute name="href"><xsl:value-of select="concat('#',@id)"/></xsl:attribute>
    	<xsl:value-of select="@name"/>
    	</a>
	</li>
</xsl:for-each>
</ul>
<h3>#/bin/bash</h3>
<xsl:if test="count(statements/statement)&gt;0">
<pre><xsl:for-each select="statements/statement">
<xsl:value-of select="text()"/><xsl:text>
</xsl:text>
</xsl:for-each></pre>
</xsl:if>
<hr/>
</xsl:template>



</xsl:stylesheet>
