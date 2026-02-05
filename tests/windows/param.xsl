<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:param name="greeting"/>
  <xsl:output method="text"/>
  <xsl:template match="/">
    <xsl:value-of select="$greeting"/>
  </xsl:template>
</xsl:stylesheet>
