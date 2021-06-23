<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:html="http://www.w3.org/1999/xhtml"
    exclude-result-prefixes="xs" version="2.0">
    
    <xsl:import href="nav_bar.xsl"/>
    
    <xsl:template match="/">
        <xsl:text disable-output-escaping='yes'>&lt;!DOCTYPE html&gt;</xsl:text>
        <html xmlns="http://www.w3.org/1999/xhtml">
            <head>
                <title>Aratea Digital Project</title>
                <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>	
                <link rel="stylesheet" type="text/css" href="css/aratea.css"/>
                <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/css/bootstrap.min.css" integrity="sha384-Vkoo8x4CGsO3+Hhxv8T/Q5PaXtkKtu6ug5TOeNV6gBiFeWPGFN9MuhOf23Q9Ifjh" crossorigin="anonymous"/>
            </head>
            
            <body>
                <xsl:call-template name="nav_bar"/>
                <div class="container">
                    <table class="table table-striped">
                        <thead>
                            <tr>
                                <th scope="col">Shelfmark</th>
                                <th scope="col">Aratea text</th>
                                <th scope="col"></th>
                                <th scope="col"></th>
                            </tr>
                        </thead>
                        <tbody>
                            <xsl:for-each select="collection('../data/descriptions')//tei:TEI">
                                <xsl:variable name="full_path">
                                    <xsl:value-of select="document-uri(/)"/>
                                </xsl:variable>
                                <tr>
                                    <td>                                        
                                        <a>
                                            <xsl:attribute name="href">                                                
                                                <xsl:value-of select="replace(tokenize($full_path, '/')[last()], '.xml', '.html')"/>
                                            </xsl:attribute>
                                            <xsl:value-of select="..//tei:fileDesc/tei:titleStmt/tei:title[@type='sub']"/>
                                        </a>
                                    </td>
                                    <td>
                                        <xsl:value-of select="..//tei:body/tei:msDesc/tei:head/tei:note[@type='aratea']"/>
                                    </td>
                                    <td>
                                        <xsl:value-of select="..//tei:body/tei:msDesc/tei:head/tei:origDate"/>
                                    </td>
                                    <td>
                                        <xsl:value-of select="..//tei:body/tei:msDesc/tei:head/tei:origPlace"/>
                                    </td>
                                </tr>
                            </xsl:for-each>
                        </tbody>
                    </table>
                </div>
                <script src="https://code.jquery.com/jquery-3.2.1.slim.min.js" integrity="sha384-KJ3o2DKtIkvYIK3UENzmM7KCkRr/rE9/Qpg6aAZGJwFDMVNA/GpGFF93hXpG5KkN" crossorigin="anonymous"/>
                <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.12.9/umd/popper.min.js" integrity="sha384-ApNbgh9B+Y1QKtv3Rn7W3mgPxhU9K/ScQsAP7hUibX39j7fakFPskvXusvfa0b4Q" crossorigin="anonymous"/>
                <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/js/bootstrap.min.js" integrity="sha384-JZR6Spejh4U02d8jOt6vLEHfe/JQGiRRSQQxSfFWpi1MquVdAyjUar5+76PVCmYl" crossorigin="anonymous"/>
            </body>
        </html>
    </xsl:template>
    <xsl:template match="tei:div//tei:head">
        <h2><xsl:apply-templates/></h2>
    </xsl:template>
    
    <xsl:template match="tei:p">
        <p><xsl:apply-templates/></p>
    </xsl:template>
    
    <xsl:template match="tei:list">
        <ul><xsl:apply-templates/></ul>
    </xsl:template>
    
    <xsl:template match="tei:item">
        <li><xsl:apply-templates/></li>
    </xsl:template>
    <xsl:template match="tei:ref">
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
    </xsl:template>
</xsl:stylesheet>
