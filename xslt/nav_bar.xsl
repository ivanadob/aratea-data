<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:html="http://www.w3.org/1999/xhtml" exclude-result-prefixes="#all" version="2.0">
    <xsl:template match="/" name="nav_bar">
        
        <nav xmlns="http://www.w3.org/1999/xhtml"
            class="navbar navbar-expand-lg navbar-light bg-light">
            <a class="navbar-brand" href="index.html">Mondsee Scriptorium</a>
            <button class="navbar-toggler" type="button" data-toggle="collapse"
                data-target="#navbarSupportedContent" aria-controls="navbarSupportedContent"
                aria-expanded="false" aria-label="Toggle navigation">
                <span class="navbar-toggler-icon"/>
            </button>
            <div class="collapse navbar-collapse" id="navbarSupportedContent">
                <ul class="navbar-nav mr-auto">
                    <li class="nav-item">
                        <a class="nav-link" href="index-mss.html">Manuscripts</a>
                    </li>
                    <li class="nav-item dropdown">
                        <a class="nav-link dropdown-toggle" href="#" id="navbarDropdown" role="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                            Indices
                        </a>
                        <div class="dropdown-menu" aria-labelledby="navbarDropdown">
                            <a class="dropdown-item" href="https://ivanadob.github.io/mondsee/listtitle.html">
                                Works
                            </a>
                            <!-- <a class="dropdown-item" href="https://ivanadob.github.io/mondsee/listperson.html">
                                Persons
                            </a>
                            <a class="dropdown-item" href="https://ivanadob.github.io/mondsee/listplace.html">
                                Places
                            </a>-->
                        </div>
                    </li>
                    <!--<li class="nav-item dropdown">
                        <a class="nav-link dropdown-toggle" href="#" id="navbarDropdown"
                            role="button" data-toggle="dropdown" aria-haspopup="true"
                            aria-expanded="false"> Texts </a>
                        <div class="dropdown-menu" aria-labelledby="navbarDropdown">
                            <xsl:for-each select="collection('../data/texts')//tei:TEI">
                                <xsl:variable name="full_path">
                                    <xsl:value-of select="document-uri(/)"/>
                                </xsl:variable>
                                <xsl:variable name="relativ_path">
                                    <xsl:value-of
                                        select="replace(tokenize($full_path, '/')[last()], '.xml', '.html')"
                                    />
                                </xsl:variable>
                                <a class="dropdown-item" href="{$relativ_path}">
                                    <xsl:value-of select=".//tei:title[@type = 'sub']/text()"/>
                                </a>
                            </xsl:for-each>
                        </div>
                    </li>-->
                    <li class="nav-item">
                        <a class="nav-link" href="https://github.com/ivanadob/mondsee">GitHub</a>
                    </li>
                </ul>
                <form class="form-inline my-2 my-lg-0" method="get" action="search.html">
                    <input class="form-control mr-sm-2" type="search" placeholder="Search" aria-label="Search" name="q"/>
                    <button class="btn btn-outline-success my-2 my-sm-0" type="submit">Search</button>
                </form>
            </div>
        </nav>
    </xsl:template>
</xsl:stylesheet>