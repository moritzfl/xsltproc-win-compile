<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:include href="include.xsl"/>
  <xsl:output method="text"/>
  <xsl:template match="/">
    <xsl:call-template name="included"/>
  </xsl:template>
</xsl:stylesheet>
