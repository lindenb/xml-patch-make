<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:x="http://exslt.org/dates-and-times"
	version="1.0"
	>
<!-- convert a xml-make to snakemake

-->
<xsl:output method="text"/>
<xsl:key name="tt" match="target" use="@id" />

<xsl:template match="/">
<xsl:apply-templates select="make"/>
</xsl:template>

<xsl:template match="make">
shell.executable("<xsl:value-of select="@shell"/>")

<xsl:for-each select="target">
 <xsl:sort select="position()" data-type="number" order="descending"/>
	<xsl:apply-templates select="."/>
</xsl:for-each>
</xsl:template>   


<xsl:template match="target">
<xsl:variable name="this" select="."/>


rule <xsl:value-of select="concat('rule',$this/@id)"/>:
	"""<xsl:value-of select="@description"/>"""

	output: <xsl:apply-templates select="." mode="phony-name"/>

	
<xsl:if test="count(prerequisites/prerequisite)&gt;0">
	input: <xsl:for-each select="prerequisites/prerequisite">
			<xsl:if test="position()&gt;1"> , </xsl:if>
			<xsl:apply-templates select="key('tt',@ref)" mode="phony-name"/>
	</xsl:for-each>
</xsl:if>
	
	shell: <xsl:if test="@phony = 1">
		"touch <xsl:apply-templates select="." mode="phony-name"/>;" \
		</xsl:if>
		<xsl:choose>
			<xsl:when test="count(statements/statement)&gt;0">
		<xsl:for-each select="statements/statement">
		<xsl:if test="position()&gt;1"> \
		</xsl:if>
		<xsl:text>"</xsl:text>
		<xsl:call-template name="escape">
			<xsl:with-param name="s" select="text()" />
		</xsl:call-template>
		<xsl:if test="position()!=last()"> ; </xsl:if>
		<xsl:text>"</xsl:text>
		
		
		</xsl:for-each>
			</xsl:when>
			<xsl:otherwise>"echo <xsl:apply-templates select="." mode="phony-name"/>"
			</xsl:otherwise>
		</xsl:choose>



</xsl:template>     

<xsl:template match="target" mode="phony-name">
<xsl:text>'</xsl:text>
<xsl:choose>
   <xsl:when test="@phony='1'"><xsl:value-of select="concat('__',@id,'_phony.flag')"/></xsl:when>
   <xsl:otherwise><xsl:value-of select="@name"/></xsl:otherwise>
</xsl:choose>
<xsl:text>'</xsl:text>
</xsl:template>


<xsl:template name="escape">
<xsl:param name="s"/>

<xsl:call-template name="escape-sub">
    <xsl:with-param name="s">
		<xsl:call-template name="escape-sub">
			<xsl:with-param name="s">
			<xsl:call-template name="escape-sub">
					<xsl:with-param name="s">
					
					<xsl:call-template name="escape-sub">
						<xsl:with-param name="s">
					
						<xsl:call-template name="escape-sub">
							<xsl:with-param name="s">
					
							<xsl:call-template name="escape-sub">
								<xsl:with-param name="s">
					
								<xsl:call-template name="escape-sub">
									<xsl:with-param name="s" select="$s"/>
									<xsl:with-param name="find" select="'\&#10;'"/>
									<xsl:with-param name="replace" select="' '"/>
								</xsl:call-template>
					
								</xsl:with-param>
								<xsl:with-param name="find" select="'\r'"/>
								<xsl:with-param name="replace" select="'\\r'"/>
							</xsl:call-template>
					
							</xsl:with-param>
							<xsl:with-param name="find" select="'\t'"/>
							<xsl:with-param name="replace" select="'\\t'"/>
						</xsl:call-template>
					
						</xsl:with-param>
						<xsl:with-param name="find" select="'\n'"/>
						<xsl:with-param name="replace" select="'\\n'"/>
					</xsl:call-template>
					
					</xsl:with-param>
					<xsl:with-param name="find" select="'{'"/>
					<xsl:with-param name="replace" select="'{{'"/>
			</xsl:call-template>	
			</xsl:with-param>
			<xsl:with-param name="find" select="'}'"/>
			<xsl:with-param name="replace" select="'}}'"/>
		</xsl:call-template>
    </xsl:with-param>
    <xsl:with-param name="find" select="'&quot;'"/>
    <xsl:with-param name="replace" select="'\&quot;'"/>
</xsl:call-template>
</xsl:template>


<xsl:template name="escape-sub">
<xsl:param name="s"/>
<xsl:param name="find"/>
<xsl:param name="replace"/>
<xsl:choose>
  <xsl:when test="contains($s,$find)">
    <xsl:value-of select="substring-before($s,$find)"/>
    <xsl:value-of select="$replace"/>
    <xsl:call-template name="escape-sub">
        <xsl:with-param name="s" select="substring-after($s,$find)"/>
        <xsl:with-param name="find" select="$find"/>
        <xsl:with-param name="replace" select="$replace"/>
    </xsl:call-template>
  </xsl:when>
  <xsl:otherwise>
    <xsl:value-of select="$s"/>
  </xsl:otherwise>
</xsl:choose>
</xsl:template>


   
</xsl:stylesheet>
