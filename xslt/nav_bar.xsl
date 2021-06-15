<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="2.0">
    
    <xsl:template match="/" name="nav_bar">

                <nav class="navbar navbar-expand-lg navbar-light bg-light">
                    <a class="navbar-brand" href="index.html">Aratea Digital</a>
                    <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarSupportedContent" aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation">
                        <span class="navbar-toggler-icon"></span>
                    </button>
                    
                    <div class="collapse navbar-collapse" id="navbarSupportedContent">
                        <ul class="navbar-nav mr-auto">
                            <!-- <li class="nav-item active">
                                <a class="nav-link" href="./index.html">Home <span class="sr-only">(current)</span></a>
                            </li> -->
                            <!-- <li class="nav-item">
                                <a class="nav-link" href="#">Link</a>
                            </li> -->
                            <li class="nav-item">
                                <a class="nav-link" href="https://github.com/ivanadob/aratea-data/html/index-mss.html">Manuscripts</a>
                            </li>
                            <!--<li class="nav-item dropdown">
                                <a class="nav-link dropdown-toggle" href="#" id="navbarDropdown" role="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                                    Descriptions
                                </a>
                                <div class="dropdown-menu" aria-labelledby="navbarDropdown">
                                    <xsl:for-each select="collection('../data/descriptions')//tei:TEI">
                                        <xsl:variable name="full_path">
                                            <xsl:value-of select="document-uri(/)"/>
                                        </xsl:variable>
                                        <xsl:variable name="relativ_path">
                                            <xsl:value-of select="replace(tokenize($full_path, '/')[last()], '.xml', '.html')"/>
                                        </xsl:variable>
                                        <a class="dropdown-item" href="{$relativ_path}">
                                            <xsl:value-of select=".//tei:title[@type='sub']/text()"/>
                                        </a>
                                    </xsl:for-each>
                                </div>
                            </li>-->
                            <li class="nav-item dropdown">
                                <a class="nav-link dropdown-toggle" href="#" id="navbarDropdown" role="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                                    Texts
                                </a>
                                <div class="dropdown-menu" aria-labelledby="navbarDropdown">
                                    <xsl:for-each select="collection('../data/texts')//tei:TEI">
                                        <xsl:variable name="full_path">
                                            <xsl:value-of select="document-uri(/)"/>
                                        </xsl:variable>
                                        <xsl:variable name="relativ_path">
                                            <xsl:value-of select="replace(tokenize($full_path, '/')[last()], '.xml', '.html')"/>
                                        </xsl:variable>
                                        <a class="dropdown-item" href="{$relativ_path}">
                                            <xsl:value-of select=".//tei:title[@type='sub']/text()"/>
                                        </a>
                                    </xsl:for-each>
                                </div>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" href="https://github.com/ivanadob/aratea-data">GitHub</a>
                            </li>
                        </ul>
                    </div>
                </nav>
    </xsl:template>
    
    
</xsl:stylesheet>