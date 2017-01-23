<?xml version="1.0" encoding="utf-8" ?>
<xsl:stylesheet
    version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns="http://www.w3.org/1999/xhtml"
    xmlns:html="http://www.w3.org/1999/xhtml"
    exclude-result-prefixes="html">

  <xsl:import href="includes/sfw_templates.xsl" />
  <xsl:import href="includes/sfw_calendar.xsl" />

  <xsl:output
      method="xml"
      doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN"
      doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd"
      version="1.0"
      indent="yes"
      omit-xml-declaration="yes"
      encoding="utf-8"/>

  <xsl:param name="sortcol" />

  <xsl:key name="events" match="/resultset/events/*" use="@edate" />

  <xsl:template match="/">
    <html>
      <head>
        <title>Case Study</title>

        <!-- SchemaFW includes -->
        <xsl:apply-templates select="." mode="fill_head" />
        <script src="cal.js"></script>
        <style type="text/css">
        div.devent { background-color:#CCCCCC; margin-bottom:6px; font-size:smaller; }
        </style>
      </head>
      <body>
        <div id="SFW_Header">
          <h1>SchemaFW Case Study</h1>
          <xsl:apply-templates select="/*/navigation" mode="header" />
        </div>
        <div id="SFW_Content">
          <div class="SFW_Host">
            <xsl:apply-templates select="/*" mode="show_document_content" />
          </div>
        </div>
      </body>
    </html>
  </xsl:template>


  <!-- The following two should not be here.  They should be
       moved to sfwtemplates.xsl or removed entirely. They
       remain only until I decide the best option. -->
  <xsl:template match="row" mode="make_option">
    <xsl:element name="option">
      <xsl:attribute name="value">
        <xsl:value-of select="@value" />
      </xsl:attribute>
      <xsl:value-of select="@label" />
    </xsl:element>
  </xsl:template>

  <xsl:template match="*[@xsl_mode='lookup']">
    <xsl:apply-templates select="row" mode="make_option" />
  </xsl:template>

  <xsl:template match="*[@rndx and local-name()='calendar']">
    <xsl:choose>
      <xsl:when test="@view='table'">
        <xsl:apply-templates select="../events" mode="make_table" />
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates select="./row" mode="build_calendar" />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="event" mode="summary">
    <div class="devent"><xsl:value-of select="@ename" /></div>
  </xsl:template>

  <xsl:template name="build_day_content">
    <xsl:param name="date" />
    <xsl:variable name="elist" select="key('events', $date)" />
    <xsl:apply-templates select="$elist" mode="summary" />
  </xsl:template>
  
</xsl:stylesheet>
