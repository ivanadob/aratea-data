<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:html="http://www.w3.org/1999/xhtml"
    exclude-result-prefixes="#all" version="2.0">
    
    <xsl:import href="nav_bar.xsl"/>
    
    <xsl:template match="/">
        <html xmlns="http://www.w3.org/1999/xhtml">
            <head>
                <title>Index of works — Aratea Digital Project</title>
                <link rel="stylesheet" type="text/css" href="css/aratea.css"/>
                <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/css/bootstrap.min.css" />
            </head>
            
            <body>
                <xsl:call-template name="nav_bar"/>
                <div class="container">
                    <span class="header">List of works in manuscripts with Aratean texts</span>
                    <table class="table table-striped">
                        <thead>
                            <tr>
                                <th scope="col">Title</th>
                                <th scope="col">Author</th>
                                <th scope="col">Summary</th>
                                <th scope="col">Inc.</th>
                                <th scope="col">Expl.</th>
                                <th scope="col">MSS</th>
                                <th scope="col">Bibliography</th>
                            </tr>
                        </thead>
                        <tbody>
                            <xsl:for-each select=".//work">
                                <tr>
                                    <td>
                                        <xsl:attribute name="id">
                                    <xsl:value-of select="@xml:id"/>
                                </xsl:attribute>
                                <xsl:apply-templates select="title"/>
                                    </td>
                                    <td>
                                        <xsl:apply-templates select="author"/>
                                    </td>
                                    <td>
                                        <xsl:apply-templates select="note"/>
                                    </td>
                                    <td>
                                        <xsl:apply-templates select="incipit"/>
                                    </td>
                                    <td>
                                        <xsl:apply-templates select="explicit"/>
                                    </td>
                                    <td>
                                        <xsl:variable name="work">
                                            <xsl:value-of select="work/@xml:id"/>
                                        </xsl:variable>
                                        <xsl:variable name="full_path">
                                            <xsl:value-of select="document-uri(/)"/>
                                        </xsl:variable>
                                        <xsl:variable name="desciprions">
                                            <xsl:value-of select="collection('../data/descriptions')//tei:TEI"/>
                                        </xsl:variable>
                                        <xsl:choose>
                                            <xsl:when test="contains($desciprions, $work)">
                                                <a>
                                                    <xsl:attribute name="href">                                                
                                                        <xsl:value-of select="replace(tokenize($full_path, '/')[last()], '.xml', '.html')"/>
                                                    </xsl:attribute>
                                                    <xsl:value-of select="..//tei:fileDesc/tei:titleStmt/tei:title[@type='sub']"/>
                                                </a>
                                            </xsl:when>
                                        </xsl:choose>
                                    </td>
                                    <td>
                                        <xsl:apply-templates select="bibl"/>                                        
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
    
    <xsl:template match="bibl[not(normalize-space(.)='')]">
        <xsl:apply-templates/>
                
                <xsl:choose>
                    <xsl:when test="following-sibling::bibl[not(normalize-space(.)='')]">
                        <xsl:text> &#x2014; </xsl:text>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:call-template name="empty_space"/>
                    </xsl:otherwise>
                </xsl:choose>
    </xsl:template>
    <xsl:template name="empty_space">
        <xsl:if test="(
            not(ends-with(normalize-space(parent::*), normalize-space(.))) and
            not(starts-with(following-sibling::node()[1],')')) and
            not(starts-with(following-sibling::node()[1],',')) and
            not(starts-with(following-sibling::node()[1],';')) and
            not(starts-with(following-sibling::node()[1],'.')) and
            not(starts-with(following-sibling::node()[1],':')) and
            not(starts-with(following-sibling::node()[1],'-')) and
            not(starts-with(following-sibling::node()[1],'–')) and
            not(starts-with(following-sibling::node()[1],']'))
            ) or starts-with(following-sibling::node()[1],'&#x2026;')">
            <xsl:text> </xsl:text>
        </xsl:if>
    </xsl:template>
    <xsl:template match="ref">
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
