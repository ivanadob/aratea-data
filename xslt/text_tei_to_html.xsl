<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:html="http://www.w3.org/1999/xhtml"
    exclude-result-prefixes="html"
    version="2.0">
    <xsl:variable name="bibliography">
        <xsl:choose>
            <xsl:when test="//tei:list[@type = 'bibliography']">
                <xsl:copy-of select="//tei:list[@type = 'bibliography']"/>
            </xsl:when>
            <xsl:when test="not($listBibl = '')">
                <xsl:copy-of select="doc($listBibl)"/>
            </xsl:when>
        </xsl:choose>
    </xsl:variable>
    <xsl:variable name="full_path">
        <xsl:value-of select="document-uri(/)"/>
    </xsl:variable>
    <xsl:variable name="gitData">https://github.com/ivanadob/aratea-data/blob/master/data/texts/</xsl:variable>
    <xsl:variable name="githubPages">https://ivanadob.github.io/aratea-data/</xsl:variable>
    <xsl:variable name="listBibl">../data/indices/listbibl.xml</xsl:variable>
    <xsl:variable name="listPerson">../data/indices/listperson.xml</xsl:variable>
    
    <xsl:import href="nav_bar.xsl"/> 
    
    <xsl:template match="/">
        <xsl:text disable-output-escaping='yes'>&lt;!DOCTYPE html&gt;</xsl:text>
        <html xmlns="http://www.w3.org/1999/xhtml">
            <head>
                <title>
                    <xsl:value-of select="descendant-or-self::tei:TEI/tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:title"/>				
                </title>
                <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>	
                <link rel="stylesheet" type="text/css" href="css/aratea.css"/>
                <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/css/bootstrap.min.css" />
            </head>
            <body>
                <xsl:call-template name="nav_bar"/>
                <div class="container">
                    <div>
                        <h1>
                            <xsl:value-of select="//tei:title[@type='sub']"/>                            
                        </h1>	
                        <p><xsl:apply-templates select="//tei:titleStmt/tei:respStmt"/></p>
                    </div>	
<!--                    Body -->
                    <xsl:apply-templates select="//tei:body"/>
                    
<!--                    Footer-->
                    <hr/>
                    <div class="copyright">
                        <a rel="license" href="http://creativecommons.org/licenses/by/4.0/" target="_blank"><img src="https://licensebuttons.net/l/by/4.0/88x31.png" width="88" height="31" alt="Creative Commons License"></img></a>
                        
                    </div>
                    <xsl:choose>
                        <xsl:when test="//tei:revisionDesc/@status = 'draft' ">
                            <xsl:text> (draft version: </xsl:text>
                            <xsl:value-of select="//tei:revisionDesc/tei:change/@when"/><xsl:text>)</xsl:text>		
                        </xsl:when>
                        <xsl:when test="//tei:revisionDesc/@status = 'complete' ">
                            <xsl:text> (last change: </xsl:text>
                            <xsl:value-of select="//tei:revisionDesc/tei:change[1]/@when"/><xsl:text>)</xsl:text>
                        </xsl:when>
                    </xsl:choose>
                    <div>
                        <xsl:text>How to quote: </xsl:text>
                        <xsl:apply-templates select="//tei:titleStmt/tei:respStmt/tei:name | //tei:titleStmt/tei:respStmt/tei:persName"/><xsl:text>, '</xsl:text>
                        <xsl:value-of select="//tei:titleStmt/tei:title[@type='sub']"/> <xsl:text> - </xsl:text> <xsl:value-of select="//tei:titleStmt/tei:title[@type='main']"/> <xsl:text>' (</xsl:text>
                        <a>
                            <xsl:attribute name="href">
                                <xsl:value-of select="concat($gitData,replace(tokenize($full_path, '/')[last()], '.html', '.xml'))"/>
                            </xsl:attribute>
                            <xsl:value-of select="concat($gitData,replace(tokenize($full_path, '/')[last()], '.html', '.xml'))"/>
                        </a>
                        <xsl:text> - last update: </xsl:text><xsl:value-of select="//tei:revisionDesc/tei:change[1]/@when"/><xsl:text>).</xsl:text>
                    </div>
                    <hr/>
                </div>
            </body>
        </html>
    </xsl:template>
    <xsl:template match="tei:div//tei:head">
        <h2 xmlns="http://www.w3.org/1999/xhtml"><xsl:apply-templates/></h2>
    </xsl:template>
    
    <xsl:template match="tei:p">
        <p xmlns="http://www.w3.org/1999/xhtml"><xsl:apply-templates/></p>
    </xsl:template>
    
    <xsl:template match="tei:list">
        <ul xmlns="http://www.w3.org/1999/xhtml"><xsl:apply-templates/></ul>
    </xsl:template>
    
    <xsl:template match="tei:item">
        <li xmlns="http://www.w3.org/1999/xhtml"><xsl:apply-templates/></li>
    </xsl:template>
    <xsl:template match="tei:ref">
        <xsl:choose>
            <xsl:when test="starts-with(data(@target), 'http')">
                <a xmlns="http://www.w3.org/1999/xhtml">
                    <xsl:attribute name="href"><xsl:value-of select="@target"/></xsl:attribute>
                    <xsl:value-of select="."/>
                </a>
            </xsl:when>
            <xsl:when test="starts-with(data(@target), '#desc')">
                <xsl:variable name="desc">
                    <xsl:value-of select="replace(tokenize(@target, '/')[last()], '.xml', '.html')"/>
                </xsl:variable>
                <a xmlns="http://www.w3.org/1999/xhtml">
                    <xsl:attribute name="href">
                        <xsl:value-of select="concat($githubPages,(substring-after($desc,'#')))"/>
                    </xsl:attribute>
                    <xsl:value-of select="."/>
                </a>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
</xsl:stylesheet>