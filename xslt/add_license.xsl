<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.tei-c.org/ns/1.0"
    xmlns:tei="http://www.tei-c.org/ns/1.0" version="2.0" xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="#all">
    <xsl:output method="xml" indent="yes" omit-xml-declaration="yes"/>
    
    <xsl:template match="//tei:titleStmt/tei:title[not(@type)]">
        <title type="main">
            Aratea Digital
        </title>
        <title type="sub">
            <xsl:apply-templates/>
        </title>
    </xsl:template>
    <xsl:template match="tei:publicationStmt">
        <xsl:if test="not(.//tei:licence)"/>
        <publicationStmt>
            <availability status="free">
                <licence target="https://creativecommons.org/licenses/by/4.0/">This document is published under the Creative Commons licence Attribution 4.0 International (CC BY 4.0).</licence>
            </availability>			      	
        </publicationStmt>
  
    </xsl:template>
    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template>
</xsl:stylesheet>