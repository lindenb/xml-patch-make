<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	version="1.0"
	xmlns:x="http://exslt.org/dates-and-times"
	>
<xsl:output method="html" encoding="UTF-8"/>
<xsl:key name="tt" match="target" use="@id" />

<xsl:template match="/">
<xsl:apply-templates select="make"/>
</xsl:template>

<xsl:template match="make">
<html>
 <head>
    <meta name="description" content="xml-patch-make - XML patch allowing GNU make to output the workflow as XML"/>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
 	<title>Makefile graph</title>
	<script type="text/javascript" src="http://alexgorbatchev.com/pub/sh/current/scripts/shCore.js"></script>
	<script type="text/javascript" src="http://alexgorbatchev.com/pub/sh/current/scripts/shBrushBash.js"></script>
	<link type="text/css" rel="stylesheet" href="http://alexgorbatchev.com/pub/sh/current/styles/shCore.css"/>
	<link type="text/css" rel="stylesheet" href="http://alexgorbatchev.com/pub/sh/current/styles/shThemeDefault.css"/>
	<script type="text/javascript">
		SyntaxHighlighter.config.clipboardSwf = 'http://alexgorbatchev.com/pub/sh/current/scripts/clipboard.swf';
		SyntaxHighlighter.all();
	</script>
 </head>
 <body>
 	<h1>Makefile graph</h1>
 	<div><b>All targets</b>: <xsl:for-each select="target">
 		 <xsl:sort select="@name"/>
 		<xsl:apply-templates select="." mode="anchor"/>
 		<xsl:text> ; </xsl:text>
 		</xsl:for-each>
 	</div>
 	<div>
 <xsl:apply-templates select="target">
        <xsl:sort select="position()" data-type="number" order="descending"/>
  </xsl:apply-templates>
   </div>
   <hr/>
   <div>Generated with <a href="https://github.com/lindenb/xml-patch-make">https://github.com/lindenb/xml-patch-make</a>. Author: Pierre Lindenbaum <a href="https://twitter.com/yokofakun">@yokofakun</a>. Date: <xsl:if test="function-available('x:date-time')"><xsl:value-of select="x:date-time()"/></xsl:if></div>
 </body>
</html>
</xsl:template>
   
   
<xsl:template match="target">
<xsl:variable name="myid" select="@id"/>
<div>
<a>
 <xsl:attribute name="name"><xsl:value-of select="$myid"/></xsl:attribute>
</a>
<h2><xsl:value-of select="@name"/></h2>
<div style="margin-left:50px;margin-right:50px;">
<xsl:if test="count(prerequisites/prerequisite)&gt;0">
<div>
<b>prerequisites : </b>
<xsl:for-each select="prerequisites/prerequisite">
 
    <a><xsl:attribute name="href"><xsl:value-of select="concat('#',@ref)"/></xsl:attribute>
    	<xsl:value-of select="@name"/>
    </a>
    <xsl:text> </xsl:text>
</xsl:for-each>
</div>
</xsl:if>

<xsl:if test="/make/target[prerequisites/prerequisite/@ref = $myid]">
<div>
<b>Used by : </b>
<xsl:for-each select="/make/target[prerequisites/prerequisite/@ref = $myid]">
	<xsl:apply-templates select="." mode="anchor"/>
	<xsl:text> </xsl:text>
</xsl:for-each>
</div>
</xsl:if>
<xsl:if test="count(statements/statement)&gt;0">
<h3>Code</h3>
<pre class="brush: bash;"><xsl:for-each select="statements/statement">
<xsl:value-of select="text()"/><xsl:text>
</xsl:text>
</xsl:for-each></pre>
</xsl:if>
</div>
</div>
<hr/>
</xsl:template>

<xsl:template match="target" mode="anchor">
<a><xsl:attribute name="href"><xsl:value-of select="concat('#',@id)"/></xsl:attribute>
<xsl:attribute name="title"><xsl:value-of select="@description"/></xsl:attribute>
    	<xsl:value-of select="@name"/>
</a>
</xsl:template>

</xsl:stylesheet>
