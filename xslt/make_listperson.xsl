<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:html="http://www.w3.org/1999/xhtml"
    exclude-result-prefixes="#all" version="2.0">
    
    <xsl:import href="nav_bar.xsl"/>
    
    <xsl:template match="/">
        <html xmlns="http://www.w3.org/1999/xhtml">
            <head>
                <title>Index of people — Aratea Digital Project</title>
                <link rel="stylesheet" type="text/css" href="css/aratea.css"/>
                <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/css/bootstrap.min.css" />
            </head>
            
            <body>
                <xsl:call-template name="nav_bar"/>
                <div class="container">
                    <span class="header">List of people mentioned in the descriptions</span>
                    <table class="table table-striped">
                        <thead>
                            <tr>
                                <th scope="col">Person</th>
                                <th scope="col">Link</th>
                                <th scope="col">MSS</th>
                            </tr>
                        </thead>
                        <tbody>
                            <xsl:for-each select=".//tei:person">
                                <tr>
                                    <td>
                                        <xsl:attribute name="id">
                                            <xsl:value-of select="@xml:id"/>
                                        </xsl:attribute>                                        
                                        <xsl:choose>
                                            <xsl:when test="tei:persName[2]">
                                                <xsl:value-of select="tei:persName[1]"/>
                                                <xsl:text>; </xsl:text>
                                                <xsl:value-of select="tei:persName[2]"/>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:value-of select="tei:persName"/>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </td>
                                    <td>
                                        <xsl:choose>
                                            <xsl:when test="(contains(tei:persName/@ref, 'gnd'))">
                                                <a>
                                                    <xsl:attribute name="href">
                                                        <xsl:value-of select="tei:persName/@ref"/>
                                                    </xsl:attribute>
                                                    <xsl:text>GND</xsl:text>
                                                </a>
                                            </xsl:when>
                                            <xsl:when test="(contains(tei:persName/@ref, 'gnd'))">
                                                <a>
                                                    <xsl:attribute name="href">
                                                        <xsl:value-of select="tei:persName/@ref"/>
                                                    </xsl:attribute>
                                                    <xsl:text>GND</xsl:text>
                                                </a>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <a>
                                                    <xsl:attribute name="href">
                                                        <xsl:value-of select="tei:persName/@ref"/>
                                                    </xsl:attribute>
                                                    <xsl:text>External link</xsl:text>
                                                </a>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </td>
                                    <td>
                                        hansi
                                    </td>
                                </tr>
                            </xsl:for-each>
                        </tbody>
                    </table>
                </div>
                <script src="https://code.jquery.com/jquery-3.2.1.slim.min.js" />
                <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.12.9/umd/popper.min.js" />
                <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/js/bootstrap.min.js" />
            </body>
        </html>
    </xsl:template>
    
    <!--<xsl:template match="tei:ref">
        <xsl:choose>
            <xsl:when test="starts-with(data(@target), 'http')">
                <a>
                    <xsl:attribute name="href"><xsl:value-of select="@target"/></xsl:attribute>
                    <xsl:value-of select="."/>
                </a>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>-->
</xsl:stylesheet>
