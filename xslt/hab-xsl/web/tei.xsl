<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:svg="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" exclude-result-prefixes="tei svg xlink" version="2.0">
    <xsl:output method="html" encoding="utf-8" indent="yes" doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd" doctype-public="-//W3C//DTD XHTML 1.0 Transitional//EN"/>

    <!-- URN-Bestandteile -->
    <xsl:param name="urn-resolver">http://nbn-resolving.de/urn/resolver.pl?urn=</xsl:param>
    <xsl:param name="urn-base">urn:nbn:</xsl:param>
    <xsl:param name="urn-country">de</xsl:param>
    <xsl:param name="urn-network">gbv</xsl:param>
    <xsl:param name="urn-library">23</xsl:param>
    <!-- Ende URN-Bestandteile -->
    <!-- Webserver für Digitalisierungen -->
    <xsl:param name="server">http://diglib.hab.de/</xsl:param>
    <xsl:param name="collection">mss</xsl:param>
    <xsl:param name="startfile">start.htm</xsl:param>
    <xsl:param name="imageParameter">?image=</xsl:param>
    <xsl:param name="facsimileData">facsimile.xml</xsl:param>
    <xsl:param name="repository_short">HAB</xsl:param>
    <xsl:param name="xmlid">
        <xsl:value-of select="replace(replace(replace(replace(replace(replace(replace(translate(translate(lower-case(//tei:msDesc/tei:msIdentifier/tei:idno),'.',''),' ','-'),'fol','2f'),'4to','4f'),'8vo','8f'),'12mo','12f'),'α','alpha'),'β','beta'),'—','--')"/>
    </xsl:param>
    <!-- Ende Webserver für Digitalisierungen -->
    <!-- Verknüpfung zur Literatur (OPAC, Literaturdatenbank, etc.) -->
    <xsl:param name="Verbund">hab</xsl:param>
    <xsl:param name="Suchfeld">ppn</xsl:param>
    <xsl:param name="OPAC">http://opac.lbs-braunschweig.gbv.de/DB=2/</xsl:param>
    <xsl:param name="searchForPPN">PPN?PPN=</xsl:param>
    <xsl:param name="searchForTerm">CMD?ACT=SRCHA&amp;TRM=</xsl:param>
    <!-- GBV: http://gso.gbv.de/DB=2.1/CMD?ACT=SRCHA&TRM=ppn+ -->
    <!--d-nb: http://dispatch.opac.ddb.de/DB=4.1/PPN?PPN=-->
    <!-- $literaturDB - mögliche Werte: eine URL der Datenbank oder leer lassen -->
    <xsl:param name="regex">(\d*)(\D)?-(\D*)-?(\d°)?</xsl:param>
    <!-- Ende Verknüpfung zur Literatur -->
    <xsl:param name="rubricationSignOpener">
        <span class="smaller">
            <xsl:text disable-output-escaping="no">&gt;</xsl:text>
        </span>
    </xsl:param>
    <xsl:param name="rubricationSignCloser">
        <span class="smaller">
            <xsl:text disable-output-escaping="no">&lt;</xsl:text>
        </span>
    </xsl:param>
    <!-- mögliche Verknüpfungen mit Ressourcen für kanonische Zitate: Bibel, MGH, etc. -->
    <xsl:param name="cRef-biblical-start">http://www.biblija.net/biblija.cgi?m=</xsl:param>
    <xsl:param name="cRef-biblical-end_de">&amp;id12=1&amp;id8=1&amp;set=1</xsl:param>
    <xsl:param name="cRef-biblical-end_en">&amp;id7=1&amp;id8=1&amp;set=1</xsl:param>
    <xsl:param name="cRef-biblical-end_fr">&amp;id9=1&amp;id8=1&amp;set=1&amp;l=fr</xsl:param>
    <xsl:param name="cRef-biblical-end_it">&amp;id7=1&amp;id8=1&amp;set=1</xsl:param>
    <!-- auch: http://www.bibelgesellschaft.de/channel.php?channel=35&INPUT=; ohne cRef-end -->
    <!-- Ende mögliche Verknüpfungen mit Ressourcen für kanonische Zitate -->
    <xsl:param name="ort">Wolfenbüttel</xsl:param>
    <xsl:param name="css-file">../styles/druck.css</xsl:param>
    <xsl:param name="Trennzeichen"> — </xsl:param>
    <xsl:param name="Status">fertig</xsl:param><!-- mögliche Werte: vorlaeufig/fertig -->
    <!-- mit externen Werten zu befüllen, aber hier zu deklarieren -->
    <xsl:param name="lang"/>
    <!-- für alle folgenden Parameter mögliche Werte: yes/no -->
    <xsl:param name="alleElementeAnzeigen">yes</xsl:param>
    <xsl:param name="EinzeldateienAusgeben">yes</xsl:param>
    <xsl:param name="mehrereKatalogisatePublizieren">no</xsl:param>
    <xsl:param name="msPartUeberschriftAnzeigen">no</xsl:param>
    <xsl:param name="registerAnzeigen">yes</xsl:param>
    <xsl:param name="abgekuerzteLiteraturAuflisten">no</xsl:param>
    <xsl:param name="Autorname">no</xsl:param>
    <xsl:template match="/">
        <xsl:apply-templates select="//tei:msDesc">
            <xsl:with-param name="sprache" select="$lang"/>
        </xsl:apply-templates>
    </xsl:template>

    <!-- ===== oberste Ebene: msDesc ===== -->
    <xsl:template match="tei:msDesc[not(. = '')]">
        <xsl:param name="sprache"/>
        <div class="msIdentifier">
            <!--<xsl:choose>
                <xsl:when test="contains(ancestor::tei:TEI/tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:title, 'Signaturdokument')">
                    <xsl:value-of select="ancestor::tei:TEI/tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:title"/>
                </xsl:when>
                <xsl:when test="contains(ancestor::tei:TEI/tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:title, concat('(', tei:additional//tei:recordHist/tei:source))">
                    <xsl:value-of select="substring-before(ancestor::tei:TEI/tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:title, concat('(', tei:additional//tei:recordHist/tei:source))"/>
                </xsl:when>
                <xsl:when test="contains(ancestor::tei:TEI/tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:title, concat(' — ', tei:additional//tei:recordHist/tei:source))">
                    <xsl:value-of select="substring-before(ancestor::tei:TEI/tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:title, concat(' — ', tei:additional//tei:recordHist/tei:source))"/>
                </xsl:when>
                <xsl:when test="contains(ancestor::tei:TEI/tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:title, ') — ')">
                    <xsl:value-of select="concat(substring-before(ancestor::tei:TEI/tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:title, ') — '), ')')"/>
                </xsl:when>
                <xsl:when test="contains(ancestor::tei:TEI/tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:title, ' — ')">
                    <xsl:value-of select="substring-before(ancestor::tei:TEI/tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:title, ' — ')"/>
                </xsl:when>
                <xsl:when test="contains(ancestor::tei:TEI/tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:title, tei:additional//tei:recordHist/tei:source)">
                    <xsl:value-of select="substring-before(ancestor::tei:TEI/tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:title, tei:additional//tei:recordHist/tei:source)"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="ancestor::tei:TEI/tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:title"/>
                </xsl:otherwise>
            </xsl:choose>-->
            HANSI4ever
        </div>
        <div class="source">
            <xsl:apply-templates select="//tei:recordHist/tei:source" mode="source">
                <xsl:with-param name="sprache" select="$lang"/>
            </xsl:apply-templates>
        </div>
        <xsl:apply-templates select="tei:head[1]">
            <xsl:with-param name="sprache" select="$lang"/>
        </xsl:apply-templates>
        <xsl:apply-templates select="tei:msIdentifier">
            <xsl:with-param name="sprache" select="$lang"/>
        </xsl:apply-templates>
        <xsl:apply-templates select="tei:physDesc">
            <xsl:with-param name="sprache" select="$lang"/>
        </xsl:apply-templates>
        <xsl:apply-templates select="tei:msContents">
            <xsl:with-param name="sprache" select="$lang"/>
        </xsl:apply-templates>
        <xsl:apply-templates select="tei:history">
            <xsl:with-param name="sprache" select="$lang"/>
        </xsl:apply-templates>
        <xsl:apply-templates select="tei:head/tei:note[@type='generalDescription']">
            <xsl:with-param name="sprache" select="$lang"/>
        </xsl:apply-templates>
        <xsl:apply-templates select="tei:additional">
            <xsl:with-param name="sprache" select="$lang"/>
        </xsl:apply-templates>
        <xsl:apply-templates select="tei:msPart">
            <xsl:with-param name="sprache" select="$lang"/>
        </xsl:apply-templates>
        <xsl:if test="ancestor::tei:TEI/tei:text[descendant::tei:div[not(normalize-space(.)='')]]">
            <hr/>
            <xsl:apply-templates select="ancestor::tei:TEI/tei:text[descendant::tei:div][not(self::tei:msDesc)]">
                <xsl:with-param name="sprache" select="$lang"/>
            </xsl:apply-templates>
        </xsl:if>
        <hr/>
        <div class="mssDoku">
            <ul>
                <li>
                    <xsl:choose>
                        <xsl:when test="$lang = 'de' ">Weitere Literaturnachweise im OPAC <a href="{concat($OPAC, $searchForTerm, '&#34;', translate(ancestor-or-self::tei:msDesc/tei:msIdentifier/tei:idno, ' ', '+'), '&#34;')}">suchen</a>.</xsl:when>
                        <xsl:when test="$lang = 'en' ">
                            <a href="{concat($OPAC, $searchForTerm, ancestor-or-self::tei:msDesc/tei:msIdentifier/tei:idno)}">Search</a> the OPAC for further literature.</xsl:when>
                        <xsl:when test="$lang = 'fr' "/>
                        <xsl:when test="$lang = 'it' "/>
                        <xsl:otherwise><xsl:value-of select="name()"/></xsl:otherwise>
                    </xsl:choose>
                </li>
                <li>
                    <xsl:choose>
                        <xsl:when test="$lang = 'de' ">Weitere Literaturnachweise <a href="{concat('?list=mssdoku&amp;id=', ancestor-or-self::tei:msDesc/tei:msIdentifier/tei:idno)}">suchen</a> (ehem. Handschriftendokumentation)</xsl:when>
                        <xsl:when test="$lang = 'en' ">
                            <a href="{concat($OPAC, $searchForTerm, ancestor-or-self::tei:msDesc/tei:msIdentifier/tei:idno)}">Search</a> the OPAC for further literature.</xsl:when>
                        <xsl:when test="$lang = 'fr' "/>
                        <xsl:when test="$lang = 'it' "/>
                        <xsl:otherwise><xsl:value-of select="name()"/></xsl:otherwise>
                    </xsl:choose>
                </li>
            </ul>
        </div>
        <xsl:choose>
            <xsl:when test="//tei:publicationStmt/tei:availability[@status='restricted' and tei:p/tei:orgName]">
                <div class="rights">
                    <xsl:choose>
                        <xsl:when test="$lang = 'de' ">Mit freundlicher Genehmigung des Verlags (<xsl:apply-templates select="//tei:publicationStmt/tei:availability//tei:orgName"/>). Das Copyright an der Handschriftenbeschreibung liegt beim Verlag.</xsl:when>
                        <xsl:when test="$lang = 'en' ">By courtesy of <xsl:apply-templates select="//tei:publicationStmt/tei:availability//tei:orgName"/>. The manuscript description is copyrighted by the publisher.</xsl:when>
                        <xsl:when test="$lang = 'fr' ">Avec l'aimable permission de <xsl:apply-templates select="//tei:publicationStmt/tei:availability//tei:orgName"/>. L'éditeur détient l'ensemble des droits de publication.</xsl:when>
                        <xsl:when test="$lang = 'it' ">Per gentile permissione di <xsl:apply-templates select="//tei:publicationStmt/tei:availability//tei:orgName"/>. Tutti diritti sono riservati all'Editore.</xsl:when>
                        <xsl:otherwise><xsl:value-of select="name()"/></xsl:otherwise>
                    </xsl:choose>
                </div>
            </xsl:when>
            <xsl:otherwise>
                <div class="rights">
                    <xsl:apply-templates select="//tei:publicationStmt/tei:availability"/>
                </div>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="tei:msPart[not(. = '')]">
        <xsl:param name="sprache"/>
        <a>
            <xsl:attribute name="name">
                <xsl:choose>
                    <xsl:when test="@xml:id">
                        <xsl:value-of select="@xml:id"/>
                    </xsl:when>
                    <xsl:when test="tei:msIdentifier">
                        <xsl:value-of select="translate(tei:msIdentifier/tei:idno,' ','_')"/>
                    </xsl:when>
                    <xsl:when test="tei:altIdentifier">
                        <xsl:value-of select="translate(tei:altIdentifier/tei:idno,' ','_')"/>
                    </xsl:when>
                </xsl:choose>
            </xsl:attribute>
        </a>
        <div class="msPart">
            <xsl:choose>
                <xsl:when test="$lang = 'de' ">Handschriftenteil: </xsl:when>
                <xsl:when test="$lang = 'en' ">Manuscript part: </xsl:when>
                <xsl:when test="$lang = 'fr' ">Partie du manuscrit: </xsl:when>
                <xsl:when test="$lang = 'it' ">Sezione del manoscritto: </xsl:when>
                <xsl:otherwise><xsl:value-of select="name()"/></xsl:otherwise>
            </xsl:choose>
            <xsl:apply-templates select="tei:msIdentifier | tei:altIdentifier">
                <xsl:with-param name="sprache" select="$lang"/>
            </xsl:apply-templates>
        </div>
        <xsl:apply-templates select="tei:head[1]">
            <xsl:with-param name="sprache" select="$lang"/>
        </xsl:apply-templates>
        <xsl:apply-templates select="tei:physDesc">
            <xsl:with-param name="sprache" select="$lang"/>
        </xsl:apply-templates>
        <xsl:apply-templates select="tei:msContents">
            <xsl:with-param name="sprache" select="$lang"/>
        </xsl:apply-templates>
        <xsl:apply-templates select="tei:history">
            <xsl:with-param name="sprache" select="$lang"/>
        </xsl:apply-templates>
        <xsl:apply-templates select="tei:head/tei:note[@type='generalDescription']">
            <xsl:with-param name="sprache" select="$lang"/>
        </xsl:apply-templates>
        <xsl:apply-templates select="tei:additional">
            <xsl:with-param name="sprache" select="$lang"/>
        </xsl:apply-templates>
        <xsl:apply-templates select="tei:msPart">
            <xsl:with-param name="sprache" select="$lang"/>
        </xsl:apply-templates>
    </xsl:template>

<!-- ===== weitere Elemente, alphabetisch sortiert ===== -->
    <xsl:template match="tei:accMat[not(. = '')]">
        <xsl:param name="sprache"/>
        <div>
            <span class="head">
                <xsl:choose>
                    <xsl:when test="$lang = 'de' ">Zusatzmaterial: </xsl:when>
                    <xsl:when test="$lang = 'en' ">Accompanying materials: </xsl:when>
                    <xsl:when test="$lang = 'fr' ">Matériel supplémentaire: </xsl:when>
                    <xsl:when test="$lang = 'it' ">Materiale addizionale: </xsl:when>
                    <xsl:otherwise><xsl:value-of select="name()"/></xsl:otherwise>
                </xsl:choose>
            </span>
            <xsl:apply-templates>
                <xsl:with-param name="sprache" select="$lang"/>
            </xsl:apply-templates>
        </div>
    </xsl:template>
    <xsl:template match="tei:acquisition[not(. = '')]">
        <xsl:param name="sprache"/>
        <div>
            <span class="head">
                <xsl:choose>
                    <xsl:when test="$lang = 'de' ">Erwerb der Handschrift: </xsl:when>
                    <xsl:when test="$lang = 'en' ">Acquisition of the manuscript: </xsl:when>
                    <xsl:when test="$lang = 'fr' ">Acquisition du manuscrit: </xsl:when>
                    <xsl:when test="$lang = 'it' ">Acquisizione del manoscritto: </xsl:when>
                    <xsl:otherwise><xsl:value-of select="name()"/></xsl:otherwise>
                </xsl:choose>
            </span>
            <xsl:choose>
                <xsl:when test="tei:p[2]">
                    <ul>
                        <xsl:apply-templates>
                            <xsl:with-param name="sprache" select="$lang"/>
                        </xsl:apply-templates>
                    </ul>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:apply-templates>
                        <xsl:with-param name="sprache" select="$lang"/>
                    </xsl:apply-templates>
                </xsl:otherwise>
            </xsl:choose>
        </div>
    </xsl:template>
    <xsl:template match="tei:additional[not(. = '')]">
        <xsl:param name="sprache"/>
        <xsl:apply-templates select="tei:listBibl">
            <xsl:with-param name="sprache" select="$lang"/>
        </xsl:apply-templates>
    </xsl:template>
    <xsl:template match="tei:additions[not(. = '')]">
        <xsl:param name="sprache"/>
        <div>
            <span class="head">
                <xsl:choose>
                    <xsl:when test="$lang = 'de' ">Spätere Ergänzungen: </xsl:when>
                    <xsl:when test="$lang = 'en' ">Additions: </xsl:when>
                    <xsl:when test="$lang = 'fr' ">Ajouts: </xsl:when>
                    <xsl:when test="$lang = 'it' ">Aggiunte: </xsl:when>
                    <xsl:otherwise><xsl:value-of select="name()"/></xsl:otherwise>
                </xsl:choose>
            </span>
            <xsl:apply-templates>
                <xsl:with-param name="sprache" select="$lang"/>
            </xsl:apply-templates>
        </div>
    </xsl:template>
    <xsl:template match="tei:altIdentifier[not(. = '')]">
        <xsl:param name="sprache"/>
        <xsl:choose>
            <xsl:when test="parent::tei:msIdentifier and     not(preceding-sibling::tei:altIdentifier[@type = current()/@type]) and     following-sibling::tei:altIdentifier[@type = current()/@type]">
                <div>
                    <xsl:call-template name="element-name">
                        <xsl:with-param name="sprache" select="$lang"/>
                        <xsl:with-param name="name">
                            <xsl:text>altIdentifier</xsl:text>
                        </xsl:with-param>
                    </xsl:call-template>
                    <ul>
                        <li>
                            <xsl:apply-templates>
                                <xsl:with-param name="sprache" select="$lang"/>
                            </xsl:apply-templates>
                        </li>
                        <xsl:apply-templates select="following-sibling::tei:altIdentifier[@type = current()/@type]">
                            <xsl:with-param name="sprache" select="$lang"/>
                        </xsl:apply-templates>
                    </ul>
                </div>
            </xsl:when>
            <xsl:when test=" parent::tei:msIdentifier and preceding-sibling::tei:altIdentifier[@type = current()/@type] ">
                <li>
                    <xsl:apply-templates>
                        <xsl:with-param name="sprache" select="$lang"/>
                    </xsl:apply-templates>
                </li>
            </xsl:when>
            <xsl:when test=" parent::tei:msIdentifier and     not(preceding-sibling::tei:altIdentifier[@type = current()/@type])">
                <div>
                    <xsl:call-template name="element-name">
                        <xsl:with-param name="sprache" select="$lang"/>
                        <xsl:with-param name="name">
                            <xsl:text>altIdentifier</xsl:text>
                        </xsl:with-param>
                    </xsl:call-template>
                    <xsl:apply-templates>
                        <xsl:with-param name="sprache" select="$lang"/>
                    </xsl:apply-templates>
                </div>
            </xsl:when>
            <xsl:when test="parent::tei:msPart">
                <xsl:apply-templates>
                    <xsl:with-param name="sprache" select="$lang"/>
                </xsl:apply-templates>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates>
                    <xsl:with-param name="sprache" select="$lang"/>
                </xsl:apply-templates>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="tei:author[not(. = '')]">
        <xsl:param name="sprache"/>
        <span>
            <xsl:choose>
                <xsl:when test="parent::tei:msItem">
                    <xsl:attribute name="class">msItemAuthor</xsl:attribute>
                </xsl:when>
                <xsl:when test="parent::tei:bibl">
                    <xsl:attribute name="class">biblAuthor</xsl:attribute>
                </xsl:when>
            </xsl:choose>
            <xsl:if test="@rend='supplied'">[</xsl:if>
            <xsl:apply-templates>
                <xsl:with-param name="sprache" select="$lang"/>
            </xsl:apply-templates>
            <xsl:if test="following-sibling::tei:title[1]">: </xsl:if>
            <xsl:if test="@rend='supplied' and not(following-sibling::tei:title[1][@rend='supplied'])">]</xsl:if>
        </span>
    </xsl:template>
    <xsl:template match="tei:bibl[not(. = '')]">
        <xsl:param name="sprache"/>
        <xsl:choose>
            <xsl:when test="parent::tei:listBibl">
                <li>
                    <xsl:apply-templates>
                        <xsl:with-param name="sprache" select="$lang"/>
                    </xsl:apply-templates>
                </li>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates>
                    <xsl:with-param name="sprache" select="$lang"/>
                </xsl:apply-templates>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="tei:biblScope[not(. = '')]">
        <xsl:value-of select="."/>
        <xsl:if test="following-sibling::tei:biblScope[1]">
            <xsl:text>, </xsl:text>
        </xsl:if>
    </xsl:template>
    <xsl:template match="tei:bindingDesc[not(. = '')]">
        <xsl:param name="sprache"/>
        <div>
            <span class="head">
                <xsl:choose>
                    <xsl:when test="$lang = 'de' ">Einband: </xsl:when>
                    <xsl:when test="$lang = 'en' ">Binding: </xsl:when>
                    <xsl:when test="$lang = 'fr' ">Reliure: </xsl:when>
                    <xsl:when test="$lang = 'it' ">Legatura: </xsl:when>
                    <xsl:otherwise><xsl:value-of select="name()"/></xsl:otherwise>
                </xsl:choose>
            </span>
            <xsl:choose>
                <xsl:when test="tei:binding[2] or tei:binding/tei:p[2]">
                    <ul>
                        <xsl:apply-templates>
                            <xsl:with-param name="sprache" select="$lang"/>
                        </xsl:apply-templates>
                    </ul>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:apply-templates>
                        <xsl:with-param name="sprache" select="$lang"/>
                    </xsl:apply-templates>
                </xsl:otherwise>
            </xsl:choose>
        </div>
    </xsl:template>
    <xsl:template match="tei:binding[not(. = '')]">
        <xsl:param name="sprache"/>
        <xsl:choose>
            <xsl:when test="preceding-sibling::tei:binding or following-sibling::tei:binding">
                <li>
                    <xsl:apply-templates>
                        <xsl:with-param name="sprache" select="$lang"/>
                    </xsl:apply-templates>
                </li>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates>
                    <xsl:with-param name="sprache" select="$lang"/>
                </xsl:apply-templates>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="tei:cb[not(. = '')]">
        <xsl:text> || </xsl:text>
    </xsl:template>
    <xsl:template match="tei:cell[not(. = '')]">
        <xsl:param name="sprache"/>
        <xsl:choose>
            <xsl:when test="parent::tei:row[@role='label']">
                <xsl:element name="th">
                    <xsl:apply-templates>
                        <xsl:with-param name="sprache" select="$lang"/>
                    </xsl:apply-templates>
                </xsl:element>
            </xsl:when>
            <xsl:when test="(@role='label')">
                <xsl:element name="th">
                    <xsl:attribute name="nowrap">nowrap</xsl:attribute>
                    <xsl:apply-templates>
                        <xsl:with-param name="sprache" select="$lang"/>
                    </xsl:apply-templates>
                </xsl:element>
            </xsl:when>
            <xsl:otherwise>
                <xsl:element name="td">
                    <xsl:if test="@rend='nowrap'">
                        <xsl:attribute name="nowrap">nowrap</xsl:attribute>
                    </xsl:if>
                    <xsl:apply-templates>
                        <xsl:with-param name="sprache" select="$lang"/>
                    </xsl:apply-templates>
                </xsl:element>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="tei:collation[not(. = '')]">
        <xsl:param name="sprache"/>
        <div>
            <span class="head">
                <xsl:choose>
                    <xsl:when test="$lang = 'de' ">Lagenstruktur: </xsl:when>
                    <xsl:when test="$lang = 'en' ">Collation: </xsl:when>
                    <xsl:when test="$lang = 'fr' ">Composition des cahiers: </xsl:when>
                    <xsl:when test="$lang = 'it' ">Composizione dei fascicoli: </xsl:when>
                    <xsl:otherwise><xsl:value-of select="name()"/></xsl:otherwise>
                </xsl:choose>
            </span>
            <xsl:apply-templates>
                <xsl:with-param name="sprache" select="$lang"/>
            </xsl:apply-templates>
        </div>
    </xsl:template>
    <xsl:template match="tei:condition[not(. = '')]">
        <xsl:param name="sprache"/>
        <div>
            <span class="head">
                <xsl:choose>
                    <xsl:when test="$lang = 'de' ">Zustand: </xsl:when>
                    <xsl:when test="$lang = 'en' ">Condition: </xsl:when>
                    <xsl:when test="$lang = 'fr' ">Etat: </xsl:when>
                    <xsl:when test="$lang = 'it' ">Condizione: </xsl:when>
                    <xsl:otherwise><xsl:value-of select="name()"/></xsl:otherwise>
                </xsl:choose>
            </span>
            <xsl:choose>
                <xsl:when test="tei:p[2]">
                    <ul>
                        <xsl:apply-templates>
                            <xsl:with-param name="sprache" select="$lang"/>
                        </xsl:apply-templates>
                    </ul>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:apply-templates>
                        <xsl:with-param name="sprache" select="$lang"/>
                    </xsl:apply-templates>
                </xsl:otherwise>
            </xsl:choose>
        </div>
    </xsl:template>
    <xsl:template match="tei:decoNote[not(. = '')]">
        <xsl:param name="sprache"/>
        <xsl:choose>
            <xsl:when test="not(preceding-sibling::tei:decoNote) and following-sibling::tei:decoNote and parent::tei:msItem">
                <xsl:text disable-output-escaping="yes">&lt;ul&gt;</xsl:text>
                <li>
                    <xsl:apply-templates>
                        <xsl:with-param name="sprache" select="$lang"/>
                    </xsl:apply-templates>
                </li>
            </xsl:when>
            <xsl:when test="preceding-sibling::tei:decoNote and following-sibling::tei:decoNote and parent::tei:msItem">
                <li>
                    <xsl:apply-templates>
                        <xsl:with-param name="sprache" select="$lang"/>
                    </xsl:apply-templates>
                </li>
            </xsl:when>
            <xsl:when test="preceding-sibling::tei:decoNote and not(following-sibling::tei:decoNote) and parent::tei:msItem">
                <li>
                    <xsl:apply-templates>
                        <xsl:with-param name="sprache" select="$lang"/>
                    </xsl:apply-templates>
                </li>
                <xsl:text disable-output-escaping="yes">&lt;/ul&gt;</xsl:text>
            </xsl:when>
            <xsl:when test="preceding-sibling::tei:decoNote or following-sibling::tei:decoNote">
                <li>
                    <xsl:apply-templates>
                        <xsl:with-param name="sprache" select="$lang"/>
                    </xsl:apply-templates>
                </li>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates>
                    <xsl:with-param name="sprache" select="$lang"/>
                </xsl:apply-templates>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="tei:decoDesc[not(. = '')]">
        <xsl:param name="sprache"/>
        <div>
            <span class="head">
                <xsl:choose>
                    <xsl:when test="$lang = 'de' ">Auszeichnungsschriften / Buchschmuck: </xsl:when>
                    <xsl:when test="$lang = 'en' ">Display script / Decoration: </xsl:when>
                    <xsl:when test="$lang = 'fr' ">Décoration: </xsl:when>
                    <xsl:when test="$lang = 'it' ">Decorazione: </xsl:when>
                    <xsl:otherwise><xsl:value-of select="name()"/></xsl:otherwise>
                </xsl:choose>
            </span>
            <xsl:choose>
                <xsl:when test="tei:decoNote[2] or tei:p[2]">
                    <ul>
                        <xsl:apply-templates>
                            <xsl:with-param name="sprache" select="$lang"/>
                        </xsl:apply-templates>
                    </ul>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:apply-templates>
                        <xsl:with-param name="sprache" select="$lang"/>
                    </xsl:apply-templates>
                </xsl:otherwise>
            </xsl:choose>
        </div>
    </xsl:template>
    <xsl:template match="tei:ex[not(. = '')]">
        <xsl:choose>
            <xsl:when test="parent::tei:rubric or parent::tei:incipit or parent::tei:quote or parent::tei:explicit or parent::tei:colophon or parent::tei:finalRubric">
                <span class="normal">
                    <xsl:text>[</xsl:text>
                    <xsl:apply-templates/>
                    <xsl:text>]</xsl:text>
                </span>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="tei:extent[not(. = '')]">
        <xsl:param name="sprache"/>
        <div>
            <span class="head">
                <xsl:if test="descendant::tei:measure[@type='leavesCount'] or descendant::tei:measure[@type='pagesCount' or text()]">
                    <xsl:choose>
                        <xsl:when test="$lang = 'de' ">Umfang: </xsl:when>
                        <xsl:when test="$lang = 'en' ">Extent: </xsl:when>
                        <xsl:when test="$lang = 'fr' ">Volume: </xsl:when>
                        <xsl:when test="$lang = 'it' ">Dimensioni: </xsl:when>
                        <xsl:otherwise><xsl:value-of select="name()"/></xsl:otherwise>
                    </xsl:choose>
                </xsl:if>
            </span>
            <xsl:apply-templates select="*[not(self::tei:measure[(@type='leavesSize') or (@type='pagesSize') or (@type='pageDimensions')])] | text()">
                <xsl:with-param name="sprache" select="$lang"/>
            </xsl:apply-templates>
        </div>
        <xsl:apply-templates select="tei:measure[(@type='leavesSize') or (@type='pagesSize') or (@type='pageDimensions')]">
            <xsl:with-param name="sprache" select="$lang"/>
        </xsl:apply-templates>
    </xsl:template>
    <xsl:template match="tei:filiation[not(. = '')]">
        <xsl:param name="sprache"/>
        <div>
            <span class="head">
                <xsl:choose>
                    <xsl:when test="$lang = 'de' ">Textgeschichte: </xsl:when>
                    <xsl:when test="$lang = 'en' ">Filiation: </xsl:when>
                    <xsl:when test="$lang = 'fr' ">Filiation: </xsl:when>
                    <xsl:when test="$lang = 'it' ">Filiazione: </xsl:when>
                    <xsl:otherwise><xsl:value-of select="name()"/></xsl:otherwise>
                </xsl:choose>
            </span>
            <xsl:choose>
                <xsl:when test="tei:p[2]">
                    <ul>
                        <xsl:apply-templates>
                            <xsl:with-param name="sprache" select="$lang"/>
                        </xsl:apply-templates>
                    </ul>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:apply-templates>
                        <xsl:with-param name="sprache" select="$lang"/>
                    </xsl:apply-templates>
                </xsl:otherwise>
            </xsl:choose>
        </div>
    </xsl:template>
    <xsl:template match="tei:foliation[not(. = '')]">
        <xsl:param name="sprache"/>
        <div>
            <span class="head">
                <xsl:choose>
                    <xsl:when test="$lang = 'de' ">Seitennummerierung: </xsl:when>
                    <xsl:when test="$lang = 'en' ">Foliation: </xsl:when>
                    <xsl:when test="$lang = 'fr' ">Numérotation des pages: </xsl:when>
                    <xsl:when test="$lang = 'it' ">Numerazione delle pagine: </xsl:when>
                    <xsl:otherwise><xsl:value-of select="name()"/></xsl:otherwise>
                </xsl:choose>
            </span>
            <xsl:apply-templates>
                <xsl:with-param name="sprache" select="$lang"/>
            </xsl:apply-templates>
        </div>
    </xsl:template>
    <xsl:template match="tei:graph[not(. = '')]">
        <xsl:param name="sprache"/>
        <object id="AdobeSVG" classid="clsid:78156a80-c6a1-4bbf-8e6a-3cd390eeb4e2"/>
        <xsl:processing-instruction name="import">namespace="svg" urn="http://www.w3.org/2000/svg" implementation="#AdobeSVG"</xsl:processing-instruction>
        <svg:svg version="1.1" baseProfile="full">
            <xsl:choose>
                <xsl:when test="@n"/>
                <xsl:otherwise>
                    <xsl:attribute name="height">100%</xsl:attribute>
                    <xsl:attribute name="width">100%</xsl:attribute>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:apply-templates>
                <xsl:with-param name="sprache" select="$lang"/>
            </xsl:apply-templates>
        </svg:svg>
    </xsl:template>
    <xsl:template match="tei:handDesc[not(. = '')]">
        <xsl:param name="sprache"/>
        <div>
            <span class="head">
                <xsl:choose>
                    <xsl:when test="$lang = 'de' ">Schrift und Hände: </xsl:when>
                    <xsl:when test="$lang = 'en' ">Writing and hands: </xsl:when>
                    <xsl:when test="$lang = 'fr' ">Type d'écritures et copistes: </xsl:when>
                    <xsl:when test="$lang = 'it' ">Tipo di scrittura e mani: </xsl:when>
                    <xsl:otherwise><xsl:value-of select="name()"/></xsl:otherwise>
                </xsl:choose>
            </span>
            <xsl:apply-templates select="tei:summary"/>
            <xsl:choose>
                <xsl:when test=" (tei:handNote[2])       or (not(tei:handNote[2]) and tei:handNote/tei:p[2])">
                    <ul>
                        <xsl:apply-templates select="tei:handNote">
                            <xsl:with-param name="sprache" select="$lang"/>
                        </xsl:apply-templates>
                    </ul>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:apply-templates>
                        <xsl:with-param name="sprache" select="$lang"/>
                    </xsl:apply-templates>
                </xsl:otherwise>
            </xsl:choose>
        </div>
    </xsl:template>
    <xsl:template match="tei:handNote[not(. = '')]">
        <xsl:param name="sprache"/>
        <xsl:choose>
            <xsl:when test="parent::tei:handDesc/tei:handNote[2]">
                <li>
                    <xsl:apply-templates>
                        <xsl:with-param name="sprache" select="$lang"/>
                    </xsl:apply-templates>
                </li>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates>
                    <xsl:with-param name="sprache" select="$lang"/>
                </xsl:apply-templates>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="tei:head[not(. = '')]">
        <xsl:param name="sprache"/>
        <xsl:choose>
            <xsl:when test="parent::tei:msDesc or parent::tei:msPart">
                <xsl:if test="tei:title">
                    <div>
                        <span class="head">
                            <xsl:choose>
                                <xsl:when test="$lang = 'de' ">Handschriftentitel: </xsl:when>
                                <xsl:when test="$lang = 'en' ">Manuscript title: </xsl:when>
                                <xsl:when test="$lang = 'fr' ">Titre du manuscrit: </xsl:when>
                                <xsl:when test="$lang = 'it' ">Titolo del codice: </xsl:when>
                                <xsl:otherwise><xsl:value-of select="name()"/></xsl:otherwise>
                            </xsl:choose>
                        </span>
                        <xsl:choose>
                            <xsl:when test="following-sibling::tei:head/tei:title">
                                <ul>
                                    <li>
                                        <xsl:apply-templates select="tei:title">
                                            <xsl:with-param name="sprache" select="$lang"/>
                                        </xsl:apply-templates>
                                    </li>
                                    <xsl:for-each select="following-sibling::tei:head/tei:title">
                                        <li>
                                            <xsl:apply-templates>
                                                <xsl:with-param name="sprache" select="$lang"/>
                                            </xsl:apply-templates>
                                        </li>
                                    </xsl:for-each>
                                </ul>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="tei:title"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </div>
                </xsl:if>
                <xsl:if test="tei:origPlace">
                    <div>
                        <span class="head">
                            <xsl:choose>
                                <xsl:when test="$lang = 'de' ">Entstehungsort: </xsl:when>
                                <xsl:when test="$lang = 'en' ">Place of origin: </xsl:when>
                                <xsl:when test="$lang = 'fr' ">Origine: </xsl:when>
                                <xsl:when test="$lang = 'it' ">Luogo di origine: </xsl:when>
                                <xsl:otherwise><xsl:value-of select="name()"/></xsl:otherwise>
                            </xsl:choose>
                        </span>
                        <xsl:value-of select="tei:origPlace"/>
                    </div>
                </xsl:if>
                <xsl:if test="tei:origDate">
                    <div>
                        <span class="head">
                            <xsl:choose>
                                <xsl:when test="$lang = 'de' ">Entstehungszeit: </xsl:when>
                                <xsl:when test="$lang = 'en' ">Date of origin: </xsl:when>
                                <xsl:when test="$lang = 'fr' ">Période: </xsl:when>
                                <xsl:when test="$lang = 'it' ">Datazione: </xsl:when>
                                <xsl:otherwise><xsl:value-of select="name()"/></xsl:otherwise>
                            </xsl:choose>
                        </span>
                        <xsl:choose>
                            <xsl:when test="count(tei:origDate) &gt; 1">
                                <ul>
                                    <xsl:for-each select="tei:origDate">
                                        <li>
                                            <xsl:apply-templates>
                                                <xsl:with-param name="sprache" select="$lang"/>
                                            </xsl:apply-templates>
                                        </li>
                                    </xsl:for-each>
                                </ul>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:apply-templates select="tei:origDate">
                                    <xsl:with-param name="sprache" select="$lang"/>
                                </xsl:apply-templates>
                            </xsl:otherwise>
                        </xsl:choose>
                    </div>
                </xsl:if>
                <xsl:if test="tei:note[@type='respStmt']">
                    <div>
                        <span class="head">
                            <xsl:choose>
                                <xsl:when test="$lang = 'de' ">Schreiber: </xsl:when>
                                <xsl:when test="$lang = 'en' ">Copyist: </xsl:when>
                                <xsl:when test="$lang = 'fr' ">Scribe: </xsl:when>
                                <xsl:when test="$lang = 'it' ">Copista: </xsl:when>
                                <xsl:otherwise><xsl:value-of select="name()"/></xsl:otherwise>
                            </xsl:choose>
                        </span>
                        <xsl:apply-templates select="tei:note[@type='respStmt']">
                            <xsl:with-param name="sprache" select="$lang"/>
                        </xsl:apply-templates>
                    </div>
                </xsl:if>
                <xsl:if test="tei:secFol">
                    <div>
                        <span class="head">
                            <xsl:choose>
                                <xsl:when test="$lang = 'de' ">Secundo folio: </xsl:when>
                                <xsl:when test="$lang = 'en' ">Second folio: </xsl:when>
                                <xsl:when test="$lang = 'fr' ">Incipit-repère: </xsl:when>
                                <xsl:when test="$lang = 'it' ">Secondo foglio: </xsl:when>
                                <xsl:otherwise><xsl:value-of select="name()"/></xsl:otherwise>
                            </xsl:choose>
                        </span>
                        <xsl:apply-templates select="tei:secFol">
                            <xsl:with-param name="sprache" select="$lang"/>
                        </xsl:apply-templates>
                    </div>
                </xsl:if>
            </xsl:when>
            <xsl:when test="parent::tei:list">
                <span class="listHead">
                    <xsl:apply-templates>
                        <xsl:with-param name="sprache" select="$lang"/>
                    </xsl:apply-templates>
                </span>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="tei:hi | tei:seg">
        <xsl:param name="sprache"/>
        <xsl:choose>
            <xsl:when test="@rend">
                <span>
                    <xsl:call-template name="attr-rend-verarbeiten">
                        <xsl:with-param name="value" select="@rend"/>
                    </xsl:call-template>
                    <xsl:apply-templates>
                        <xsl:with-param name="sprache" select="$lang"/>
                    </xsl:apply-templates>
                </span>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates>
                    <xsl:with-param name="sprache" select="$lang"/>
                </xsl:apply-templates>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="tei:history[not(. = '')]">
        <xsl:param name="sprache"/>
        <xsl:apply-templates select="tei:origin">
            <xsl:with-param name="sprache" select="$lang"/>
        </xsl:apply-templates>
        <xsl:if test="tei:provenance">
            <div>
                <span class="head">
                    <xsl:choose>
                        <xsl:when test="$lang = 'de' ">Provenienz der Handschrift: </xsl:when>
                        <xsl:when test="$lang = 'en' ">Provenance of the manuscript: </xsl:when>
                        <xsl:when test="$lang = 'fr' ">Provenance du manuscrit: </xsl:when>
                        <xsl:when test="$lang = 'it' ">Provenienza del manoscritto: </xsl:when>
                        <xsl:otherwise><xsl:value-of select="name()"/></xsl:otherwise>
                    </xsl:choose>
                </span>
                <xsl:choose>
                    <xsl:when test="count(tei:provenance) &gt; 1">
                        <ul>
                            <xsl:apply-templates select="tei:provenance">
                                <xsl:with-param name="sprache" select="$lang"/>
                            </xsl:apply-templates>
                        </ul>
                    </xsl:when>
                    <xsl:when test="count(tei:provenance/tei:p) &gt; 1">
                        <ul>
                            <xsl:apply-templates select="tei:provenance">
                                <xsl:with-param name="sprache" select="$lang"/>
                            </xsl:apply-templates>
                        </ul>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:apply-templates select="tei:provenance">
                            <xsl:with-param name="sprache" select="$lang"/>
                        </xsl:apply-templates>
                    </xsl:otherwise>
                </xsl:choose>
            </div>
        </xsl:if>
        <xsl:apply-templates select="tei:acquisition">
            <xsl:with-param name="sprache" select="$lang"/>
        </xsl:apply-templates>
    </xsl:template>
    <xsl:template match="tei:collection | tei:settlement | tei:repository">
        <xsl:apply-templates>
            <xsl:with-param name="sprache" select="$lang"/>
        </xsl:apply-templates>
        <xsl:if test="(   following-sibling::tei:settlement    or following-sibling::tei:repository    or following-sibling::tei:collection    or following-sibling::tei:idno)    and not(ends-with(., '.'))">
            <xsl:text>,</xsl:text>
        </xsl:if>
        <xsl:text> </xsl:text>
    </xsl:template>
    <xsl:template match="tei:idno">
        <xsl:choose>
            <xsl:when test="preceding-sibling::tei:collection = 'Handschriftencensus-Nr.' ">
                <a href="http://www.handschriftencensus.de/{.}">
                    <xsl:apply-templates>
                        <xsl:with-param name="sprache" select="$lang"/>
                    </xsl:apply-templates>
                </a>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates>
                    <xsl:with-param name="sprache" select="$lang"/>
                </xsl:apply-templates>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="tei:incipit | tei:explicit | tei:quote">
        <xsl:param name="sprache"/>
        <xsl:if test="starts-with(normalize-space(.),normalize-space(tei:locus[1]))">
            <xsl:apply-templates select="tei:locus">
                <xsl:with-param name="sprache" select="$lang"/>
            </xsl:apply-templates>
        </xsl:if>
        <xsl:if test="contains(@rend,'rubric')">
            <xsl:choose>
                <xsl:when test="$rubricationSignOpener != '&gt;' ">
                    <xsl:value-of select="$rubricationSignOpener"/>
                </xsl:when>
                <xsl:otherwise>
                    <span class="smaller">
                        <xsl:text disable-output-escaping="no">&gt;</xsl:text>
                    </span>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:if>
        <span>
            <xsl:call-template name="attr-rend-verarbeiten">
                <xsl:with-param name="value" select="@rend"/>
            </xsl:call-template>
            <xsl:if test="tei:lb and not(child::node()[1][local-name() = 'lb']) and not(starts-with(normalize-space(parent::node()), normalize-space(.)))">
                <br/>
            </xsl:if>
            <xsl:choose>
                <xsl:when test="tei:locus and starts-with(normalize-space(.),normalize-space(tei:locus[1]))">
                    <xsl:apply-templates select="*[not(self::tei:locus)] | text()">
                        <xsl:with-param name="sprache" select="$lang"/>
                    </xsl:apply-templates>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:apply-templates>
                        <xsl:with-param name="sprache" select="$lang"/>
                    </xsl:apply-templates>
                </xsl:otherwise>
            </xsl:choose>
        </span>
        <xsl:if test="contains(@rend,'rubric')">
            <xsl:choose>
                <xsl:when test="$rubricationSignCloser != '&lt;' ">
                    <xsl:value-of select="$rubricationSignOpener"/>
                </xsl:when>
                <xsl:otherwise>
                    <span class="smaller">
                        <xsl:text disable-output-escaping="no">&lt;</xsl:text>
                    </span>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:if>
        <xsl:if test="contains(@rend,'dots-after')">...</xsl:if>
        <xsl:if test="not(contains(self::tei:incipit/@rend,'dots-after'))    and (self::tei:incipit and following-sibling::tei:explicit and not(following-sibling::tei:quote)) or    (self::tei:quote and following-sibling::tei:explicit)"> ...–... </xsl:if>
    </xsl:template>
    <xsl:template match="tei:index">
        <xsl:param name="sprache"/>
        <ul>
            <xsl:apply-templates select="tei:term">
                <xsl:with-param name="sprache" select="$lang"/>
            </xsl:apply-templates>
        </ul>
    </xsl:template>
    <xsl:template match="tei:item[not(. = '')]">
        <xsl:param name="sprache"/>
        <li>
            <xsl:apply-templates>
                <xsl:with-param name="sprache" select="$lang"/>
            </xsl:apply-templates>
        </li>
    </xsl:template>
    <xsl:template match="tei:l">
        <xsl:apply-templates/>
        <xsl:if test="parent::tei:lg and not(position() = last())">
            <br/>
        </xsl:if>
    </xsl:template>
    <xsl:template match="tei:layoutDesc[not(. = '')]">
        <xsl:param name="sprache"/>
        <div>
            <span class="head">
                <xsl:choose>
                    <xsl:when test="$lang = 'de' ">Seiteneinrichtung: </xsl:when>
                    <xsl:when test="$lang = 'en' ">Page layout: </xsl:when>
                    <xsl:when test="$lang = 'fr' ">Mise en page: </xsl:when>
                    <xsl:when test="$lang = 'it' ">Disposizione della pagina: </xsl:when>
                    <xsl:otherwise><xsl:value-of select="name()"/></xsl:otherwise>
                </xsl:choose>
            </span>
            <xsl:choose>
                <xsl:when test="tei:layout[2] or tei:p[2]">
                    <ul>
                        <xsl:apply-templates>
                            <xsl:with-param name="sprache" select="$lang"/>
                        </xsl:apply-templates>
                    </ul>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:apply-templates>
                        <xsl:with-param name="sprache" select="$lang"/>
                    </xsl:apply-templates>
                </xsl:otherwise>
            </xsl:choose>
        </div>
    </xsl:template>
    <xsl:template match="tei:lb">
        <br/>
        <xsl:if test="@n">
            <span class="line-number">
                <xsl:value-of select="concat(@n,' ')"/>
            </span>
        </xsl:if>
    </xsl:template>
    <xsl:template match="tei:lg">
        <div class="lg">
            <xsl:apply-templates/>
        </div>
    </xsl:template>
    <xsl:template match="tei:list[not(. = '')]">
        <xsl:param name="sprache"/>
        <ul>
            <xsl:apply-templates>
                <xsl:with-param name="sprache" select="$lang"/>
            </xsl:apply-templates>
        </ul>
    </xsl:template>
    <xsl:template match="tei:listBibl[not(. = '')]">
        <xsl:param name="sprache"/>
        <xsl:choose>
            <xsl:when test="tei:listBibl[2]">
                <xsl:apply-templates>
                    <xsl:with-param name="sprache" select="$lang"/>
                </xsl:apply-templates>
            </xsl:when>
            <xsl:when test="tei:head">
                <div class="head">
                    <xsl:value-of select="tei:head"/>
                </div>
                <ul>
                    <xsl:apply-templates>
                        <xsl:with-param name="sprache" select="$lang"/>
                    </xsl:apply-templates>
                </ul>
            </xsl:when>
            <xsl:when test="ancestor::tei:additional and not(tei:head)">
                <div class="head">
                    <xsl:choose>
                        <xsl:when test="$lang = 'de' ">Bibliographie</xsl:when>
                        <xsl:when test="$lang = 'en' ">Bibliography</xsl:when>
                        <xsl:when test="$lang = 'fr' ">Bibliographie</xsl:when>
                        <xsl:when test="$lang = 'it' ">Bibliografia</xsl:when>
                        <xsl:otherwise><xsl:value-of select="name()"/></xsl:otherwise>
                    </xsl:choose>
                </div>
                <ul>
                    <xsl:apply-templates>
                        <xsl:with-param name="sprache" select="$lang"/>
                    </xsl:apply-templates>
                </ul>
            </xsl:when>
            <xsl:otherwise>
                <ul>
                    <xsl:apply-templates>
                        <xsl:with-param name="sprache" select="$lang"/>
                    </xsl:apply-templates>
                </ul>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="tei:locus[not(. = '')]">
        <xsl:param name="sprache"/>
        <xsl:if test="parent::tei:rubric or parent::tei:incipit or parent::tei:quote or parent::tei:explicit or parent::tei:colophon or parent::tei:finalRubric">
            <xsl:text disable-output-escaping="yes">&lt;span class="normal"&gt;</xsl:text>
        </xsl:if>
        <xsl:if test="parent::tei:msItem/parent::tei:msItem">
            <xsl:text>(</xsl:text>
        </xsl:if>
        <xsl:choose>
            <xsl:when test="@from and @to and contains(.,'-')">
                <xsl:choose>
                    <xsl:when test="contains(.,'Fol. ') or contains(.,'fol. ') or contains(.,'f. ') or contains(.,'P. ') or contains(.,'p. ') or contains(.,'Pp. ') or contains(.,'pp. ') or contains(.,'S. ') or contains(.,'c. ') or contains(.,'cc. ')">
                        <xsl:value-of select="concat(substring-before(.,'. '),'. ')"/>
                        <xsl:call-template name="locus-verarbeiten">
                            <xsl:with-param name="attribute">
                                <xsl:value-of select="@from"/>
                            </xsl:with-param>
                            <xsl:with-param name="content">
                                <xsl:value-of select="substring-after(substring-before(.,'-'),'. ')"/>
                            </xsl:with-param>
                        </xsl:call-template>
                        <xsl:text>-</xsl:text>
                        <xsl:call-template name="locus-verarbeiten">
                            <xsl:with-param name="attribute">
                                <xsl:value-of select="@to"/>
                            </xsl:with-param>
                            <xsl:with-param name="content">
                                <xsl:value-of select="substring-after(.,'-')"/>
                            </xsl:with-param>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:when test="contains(.,'f ')">
                        <xsl:value-of select="concat(substring-before(.,'. '),' ')"/>
                        <xsl:call-template name="locus-verarbeiten">
                            <xsl:with-param name="attribute">
                                <xsl:value-of select="@from"/>
                            </xsl:with-param>
                            <xsl:with-param name="content">
                                <xsl:value-of select="substring-after(substring-before(.,'-'),' ')"/>
                            </xsl:with-param>
                        </xsl:call-template>
                        <xsl:text>-</xsl:text>
                        <xsl:call-template name="locus-verarbeiten">
                            <xsl:with-param name="attribute">
                                <xsl:value-of select="@to"/>
                            </xsl:with-param>
                            <xsl:with-param name="content">
                                <xsl:value-of select="substring-after(.,'-')"/>
                            </xsl:with-param>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:call-template name="locus-verarbeiten">
                            <xsl:with-param name="attribute">
                                <xsl:value-of select="@from"/>
                            </xsl:with-param>
                            <xsl:with-param name="content">
                                <xsl:value-of select="substring-before(.,'-')"/>
                            </xsl:with-param>
                        </xsl:call-template>
                        <xsl:text>-</xsl:text>
                        <xsl:call-template name="locus-verarbeiten">
                            <xsl:with-param name="attribute">
                                <xsl:value-of select="@to"/>
                            </xsl:with-param>
                            <xsl:with-param name="content">
                                <xsl:value-of select="substring-after(.,'-')"/>
                            </xsl:with-param>
                        </xsl:call-template>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="@from and @to and contains(.,'–')">
                <xsl:choose>
                    <xsl:when test="contains(.,'Fol. ') or contains(.,'fol. ') or contains(.,'f. ') or contains(.,'P. ') or contains(.,'p. ') or contains(.,'Pp. ') or contains(.,'pp. ') or contains(.,'S. ') or contains(.,'c. ') or contains(.,'cc. ')">
                        <xsl:value-of select="concat(substring-before(.,'. '),'. ')"/>
                        <xsl:call-template name="locus-verarbeiten">
                            <xsl:with-param name="attribute">
                                <xsl:value-of select="@from"/>
                            </xsl:with-param>
                            <xsl:with-param name="content">
                                <xsl:value-of select="substring-after(substring-before(.,'–'),'. ')"/>
                            </xsl:with-param>
                        </xsl:call-template>
                        <xsl:text>–</xsl:text>
                        <xsl:call-template name="locus-verarbeiten">
                            <xsl:with-param name="attribute">
                                <xsl:value-of select="@to"/>
                            </xsl:with-param>
                            <xsl:with-param name="content">
                                <xsl:value-of select="substring-after(.,'–')"/>
                            </xsl:with-param>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:call-template name="locus-verarbeiten">
                            <xsl:with-param name="attribute">
                                <xsl:value-of select="@from"/>
                            </xsl:with-param>
                            <xsl:with-param name="content">
                                <xsl:value-of select="substring-before(.,'–')"/>
                            </xsl:with-param>
                        </xsl:call-template>
                        <xsl:text>–</xsl:text>
                        <xsl:call-template name="locus-verarbeiten">
                            <xsl:with-param name="attribute">
                                <xsl:value-of select="@to"/>
                            </xsl:with-param>
                            <xsl:with-param name="content">
                                <xsl:value-of select="substring-after(.,'–')"/>
                            </xsl:with-param>
                        </xsl:call-template>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="@from and @to and contains(.,'/')">
                <xsl:choose>
                    <xsl:when test="contains(.,'Fol. ') or contains(.,'fol. ') or contains(.,'f. ') or contains(.,'P. ') or contains(.,'p. ') or contains(.,'Pp. ') or contains(.,'pp. ') or contains(.,'S. ') or contains(.,'c. ') or contains(.,'cc. ')">
                        <xsl:value-of select="concat(substring-before(.,'. '),'. ')"/>
                        <xsl:call-template name="locus-verarbeiten">
                            <xsl:with-param name="attribute">
                                <xsl:value-of select="@from"/>
                            </xsl:with-param>
                            <xsl:with-param name="content">
                                <xsl:value-of select="substring-after(substring-before(.,'/'),'. ')"/>
                            </xsl:with-param>
                        </xsl:call-template>
                        <xsl:text>/</xsl:text>
                        <xsl:call-template name="locus-verarbeiten">
                            <xsl:with-param name="attribute">
                                <xsl:value-of select="@to"/>
                            </xsl:with-param>
                            <xsl:with-param name="content">
                                <xsl:value-of select="substring-after(.,'/')"/>
                            </xsl:with-param>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:call-template name="locus-verarbeiten">
                            <xsl:with-param name="attribute">
                                <xsl:value-of select="@from"/>
                            </xsl:with-param>
                            <xsl:with-param name="content">
                                <xsl:value-of select="substring-before(.,'/')"/>
                            </xsl:with-param>
                        </xsl:call-template>
                        <xsl:text>/</xsl:text>
                        <xsl:call-template name="locus-verarbeiten">
                            <xsl:with-param name="attribute">
                                <xsl:value-of select="@to"/>
                            </xsl:with-param>
                            <xsl:with-param name="content">
                                <xsl:value-of select="substring-after(.,'/')"/>
                            </xsl:with-param>
                        </xsl:call-template>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="@from">
                <xsl:choose>
                    <xsl:when test="contains(.,'Fol. ') or contains(.,'fol. ') or contains(.,'f. ') or contains(.,'P. ') or contains(.,'p. ') or contains(.,'Pp. ') or contains(.,'pp. ') or contains(.,'S. ') or contains(.,'c. ') or contains(.,'cc. ')">
                        <xsl:value-of select="concat(substring-before(.,'. '),'. ')"/>
                        <xsl:call-template name="locus-verarbeiten">
                            <xsl:with-param name="attribute">
                                <xsl:value-of select="@from"/>
                            </xsl:with-param>
                            <xsl:with-param name="content">
                                <xsl:value-of select="substring-after(.,'. ')"/>
                            </xsl:with-param>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:when test="contains(.,@from)">
                        <xsl:value-of select="substring-before(.,@from)"/>
                        <xsl:call-template name="locus-verarbeiten">
                            <xsl:with-param name="attribute">
                                <xsl:value-of select="@from"/>
                            </xsl:with-param>
                            <xsl:with-param name="content">
                                <xsl:value-of select="@from"/>
                            </xsl:with-param>
                        </xsl:call-template>
                        <xsl:value-of select="substring-after(.,@from)"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:call-template name="locus-verarbeiten">
                            <xsl:with-param name="attribute">
                                <xsl:value-of select="@from"/>
                            </xsl:with-param>
                            <xsl:with-param name="content">
                                <xsl:value-of select="."/>
                            </xsl:with-param>
                        </xsl:call-template>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="@target and not(contains(@target,' '))">
                <xsl:choose>
                    <xsl:when test="contains(.,'Fol. ') or contains(.,'fol. ') or contains(.,'f. ') or contains(.,'P. ') or contains(.,'p. ') or contains(.,'Pp. ') or contains(.,'pp. ') or contains(.,'S. ') or contains(.,'c. ') or contains(.,'cc. ')">
                        <xsl:value-of select="concat(substring-before(.,'. '),'. ')"/>
                        <xsl:call-template name="locus-verarbeiten">
                            <xsl:with-param name="attribute">
                                <xsl:value-of select="@target"/>
                            </xsl:with-param>
                            <xsl:with-param name="content">
                                <xsl:value-of select="substring-after(.,'. ')"/>
                            </xsl:with-param>
                        </xsl:call-template>
                    </xsl:when>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="locus-verarbeiten">
                    <xsl:with-param name="attribute">
                        <xsl:value-of select="."/>
                    </xsl:with-param>
                    <xsl:with-param name="content">
                        <xsl:value-of select="."/>
                    </xsl:with-param>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:if test="parent::tei:locusGrp and following-sibling::tei:locus">, </xsl:if>
        <xsl:if test="parent::tei:msItem/parent::tei:msItem">
            <xsl:text>) </xsl:text>
        </xsl:if>
        <xsl:if test="parent::tei:rubric or parent::tei:incipit or parent::tei:quote or parent::tei:explicit or parent::tei:colophon or parent::tei:finalRubric">
            <xsl:text disable-output-escaping="yes">&lt;/span&gt;</xsl:text>
        </xsl:if>
<!--	<xsl:if test="not(starts-with(following::node()[1],')') or starts-with(following::node()[1],'.') or starts-with(following::node(),',') or starts-with(following::node()[1],'?') )"><xsl:text> </xsl:text></xsl:if>-->
    </xsl:template>
    <xsl:template match="tei:measure[not(. = '')] | tei:dimensions[not(. = '')]">
        <xsl:param name="sprache"/>
        <xsl:choose>
            <xsl:when test=" (@type='leavesSize') or (@type='pagesSize') or (@type='pageDimensions') or (@type='leaf') ">
                <div>
                    <span class="head">
                        <xsl:choose>
                            <xsl:when test="$lang = 'de' ">Format: </xsl:when>
                            <xsl:when test="$lang = 'en' ">Format: </xsl:when>
                            <xsl:when test="$lang = 'fr' ">Format: </xsl:when>
                            <xsl:when test="$lang = 'it' ">Formato: </xsl:when>
                            <xsl:otherwise><xsl:value-of select="name()"/></xsl:otherwise>
                        </xsl:choose>
                    </span>
                    <xsl:apply-templates>
                        <xsl:with-param name="sprache" select="$lang"/>
                    </xsl:apply-templates>
                </div>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates>
                    <xsl:with-param name="sprache" select="$lang"/>
                </xsl:apply-templates>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="tei:height">
        <xsl:param name="sprache"/>
        <xsl:apply-templates>
            <xsl:with-param name="sprache" select="$lang"/>
        </xsl:apply-templates>
        <xsl:if test="following-sibling::tei:width or following-sibling::tei:depth">
            <xsl:text> × </xsl:text>
        </xsl:if>
    </xsl:template>
    <xsl:template match="tei:width">
        <xsl:param name="sprache"/>
        <xsl:apply-templates>
            <xsl:with-param name="sprache" select="$lang"/>
        </xsl:apply-templates>
        <xsl:if test="following-sibling::tei:depth">
            <xsl:text> × </xsl:text>
        </xsl:if>
        <xsl:if test="not(following-sibling::tei:depth)">
            <xsl:choose>
                <xsl:when test="@unit">
                    <xsl:text> </xsl:text>
                    <xsl:value-of select="@unit"/>
                </xsl:when>
                <xsl:when test="parent::tei:dimensions/@unit">
                    <xsl:text> </xsl:text>
                    <xsl:value-of select="parent::tei:dimensions/@unit"/>
                </xsl:when>
            </xsl:choose>
        </xsl:if>
    </xsl:template>
    <xsl:template match="tei:depth">
        <xsl:param name="sprache"/>
        <xsl:apply-templates>
            <xsl:with-param name="sprache" select="$lang"/>
        </xsl:apply-templates>
        <xsl:choose>
            <xsl:when test="@unit">
                <xsl:value-of select="@unit"/>
            </xsl:when>
            <xsl:when test="parent::tei:dimensions/@unit">
                <xsl:value-of select="parent::tei:dimensions/@unit"/>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="tei:msContents[not(. = '')]">
        <xsl:param name="sprache"/>
        <xsl:if test="tei:textLang">
            <div>
                <xsl:apply-templates select="tei:textLang">
                    <xsl:with-param name="sprache" select="$lang"/>
                </xsl:apply-templates>
            </div>
        </xsl:if>
        <xsl:if test="tei:summary or tei:msItem or tei:p">
            <div class="head">
                <xsl:choose>
                    <xsl:when test="$lang = 'de' ">Inhalt: </xsl:when>
                    <xsl:when test="$lang = 'en' ">Contents: </xsl:when>
                    <xsl:when test="$lang = 'fr' ">Sommaire: </xsl:when>
                    <xsl:when test="$lang = 'it' ">Contenuto: </xsl:when>
                    <xsl:otherwise><xsl:value-of select="name()"/></xsl:otherwise>
                </xsl:choose>
            </div>
            <div>
                <xsl:choose>
                    <xsl:when test="tei:p[2]">
                        <ul>
                            <xsl:apply-templates select="*[not(self::tei:textLang)]">
                                <xsl:with-param name="sprache" select="$lang"/>
                            </xsl:apply-templates>
                        </ul>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:apply-templates select="tei:summary">
                            <xsl:with-param name="sprache" select="$lang"/>
                        </xsl:apply-templates>
                        <xsl:choose>
                            <xsl:when test="tei:msItem[2] and tei:msItem[@n]">
                                <ol type="{@n}">
                                    <xsl:apply-templates select="tei:msItem">
                                        <xsl:with-param name="sprache" select="$lang"/>
                                    </xsl:apply-templates>
                                </ol>
                            </xsl:when>
                            <xsl:when test="tei:msItem[2]">
                                <ul>
                                    <xsl:apply-templates select="tei:msItem">
                                        <xsl:with-param name="sprache" select="$lang"/>
                                    </xsl:apply-templates>
                                </ul>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:apply-templates select="tei:msItem">
                                    <xsl:with-param name="sprache" select="$lang"/>
                                </xsl:apply-templates>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:otherwise>
                </xsl:choose>
            </div>
        </xsl:if>
    </xsl:template>
    <xsl:template match="tei:msIdentifier[not(. = '')]">
        <xsl:param name="sprache"/>
        <xsl:choose>
            <xsl:when test="tei:msName[2]">
                <div>
                    <xsl:call-template name="element-name">
                        <xsl:with-param name="sprache" select="$lang"/>
                        <xsl:with-param name="name">
                            <xsl:text>msName</xsl:text>
                        </xsl:with-param>
                    </xsl:call-template>
                    <ul>
                        <xsl:apply-templates select="tei:msName">
                            <xsl:with-param name="sprache" select="$lang"/>
                        </xsl:apply-templates>
                    </ul>
                </div>
            </xsl:when>
            <xsl:when test="tei:msName">
                <div>
                    <xsl:call-template name="element-name">
                        <xsl:with-param name="sprache" select="$lang"/>
                        <xsl:with-param name="name">
                            <xsl:text>msName</xsl:text>
                        </xsl:with-param>
                    </xsl:call-template>
                    <xsl:apply-templates select="tei:msName">
                        <xsl:with-param name="sprache" select="$lang"/>
                    </xsl:apply-templates>
                </div>
            </xsl:when>
        </xsl:choose>
        <xsl:if test="parent::tei:msPart">
            <xsl:apply-templates/>
        </xsl:if>
        <xsl:apply-templates select="tei:altIdentifier[not(@type = preceding-sibling::tei:altIdentifier/@type)]">
            <xsl:with-param name="sprache" select="$lang"/>
        </xsl:apply-templates>
    </xsl:template>
    <xsl:template match="tei:msItem[not(. = '')]">
        <xsl:param name="sprache"/>
        <xsl:choose>
            <xsl:when test="preceding-sibling::tei:msItem or following-sibling::tei:msItem">
                <li>
                    <xsl:if test="@n">
                        <xsl:attribute name="value">
                            <xsl:value-of select="@n"/>
                        </xsl:attribute>
                    </xsl:if>
                    <xsl:apply-templates select="*[not(self::tei:index)]">
                        <xsl:with-param name="sprache" select="$lang"/>
                    </xsl:apply-templates>
                </li>
            </xsl:when>
            <xsl:otherwise>
                <xsl:if test="@n">
                    <xsl:value-of select="@n"/>
                    <xsl:text>. </xsl:text>
                </xsl:if>
                <xsl:apply-templates select="*[not(self::tei:index)]">
                    <xsl:with-param name="sprache" select="$lang"/>
                </xsl:apply-templates>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="tei:musicNotation[not(. = '')]">
        <xsl:param name="sprache"/>
        <div>
            <span class="head">
                <xsl:choose>
                    <xsl:when test="$lang = 'de' ">Musiknotationen: </xsl:when>
                    <xsl:when test="$lang = 'en' ">Musical notations: </xsl:when>
                    <xsl:when test="$lang = 'fr' ">Notation musicale: </xsl:when>
                    <xsl:when test="$lang = 'it' ">Notazione musicale: </xsl:when>
                    <xsl:otherwise><xsl:value-of select="name()"/></xsl:otherwise>
                </xsl:choose>
            </span>
            <xsl:apply-templates>
                <xsl:with-param name="sprache" select="$lang"/>
            </xsl:apply-templates>
        </div>
    </xsl:template>
    <xsl:template match="tei:note[not(. = '')]">
        <xsl:param name="sprache"/>
        <xsl:choose>
            <xsl:when test="parent::tei:altIdentifier">
                <xsl:text>; </xsl:text>
                <xsl:apply-templates>
                    <xsl:with-param name="sprache" select="$lang"/>
                </xsl:apply-templates>
            </xsl:when>
            <xsl:when test="parent::tei:head and (@type = 'generalDescription')">
                <div>
                    <span class="head">
                        <xsl:choose>
                            <xsl:when test="$lang = 'de' ">Überblicksbeschreibung: </xsl:when>
                            <xsl:when test="$lang = 'en' ">General description: </xsl:when>
                            <xsl:when test="$lang = 'fr' ">Description générale: </xsl:when>
                            <xsl:when test="$lang = 'it' ">Descrizione generale: </xsl:when>
                            <xsl:otherwise><xsl:value-of select="name()"/></xsl:otherwise>
                        </xsl:choose>
                    </span>
                    <xsl:apply-templates>
                        <xsl:with-param name="sprache" select="$lang"/>
                    </xsl:apply-templates>
                </div>
            </xsl:when>
            <xsl:when test="@place = 'foot' ">
                <span class="footnote">
                    <xsl:text> (</xsl:text>
                    <xsl:choose>
                        <xsl:when test="$lang = 'de' ">Anmerkung: </xsl:when>
                        <xsl:when test="$lang = 'en' ">Note: </xsl:when>
                        <xsl:when test="$lang = 'fr' ">Note: </xsl:when>
                        <xsl:when test="$lang = 'it' ">Nota: </xsl:when>
                        <xsl:otherwise><xsl:value-of select="name()"/></xsl:otherwise>
                    </xsl:choose>
                    <xsl:text> </xsl:text>
                    <xsl:apply-templates>
                        <xsl:with-param name="sprache" select="$lang"/>
                    </xsl:apply-templates>
                    <xsl:text>)</xsl:text>
                </span>
            </xsl:when>
            <xsl:when test="parent::tei:rubric or parent::tei:incipit or parent::tei:quote or parent::tei:explicit or parent::tei:colophon or parent::tei:finalRubric">
                <span class="normal">
                    <xsl:apply-templates>
                        <xsl:with-param name="sprache" select="$lang"/>
                    </xsl:apply-templates>
                </span>
            </xsl:when>
            <xsl:when test="parent::tei:msItem">
                <xsl:text> </xsl:text>
                <xsl:apply-templates>
                    <xsl:with-param name="sprache" select="$lang"/>
                </xsl:apply-templates>
                <xsl:text>. </xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates>
                    <xsl:with-param name="sprache" select="$lang"/>
                </xsl:apply-templates>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:if test="preceding-sibling::node()[1][name()='tei:incipit'] and following-sibling::node()[1][name()='tei:explicit']">
            <xsl:text>... - ...</xsl:text>
        </xsl:if>
    </xsl:template>
    <xsl:template match="tei:orgName[not(. = '')]">
        <xsl:choose>
            <xsl:when test="@xml:base">
                <a href="{@xml:base}" rel="external" target="_blank">
                    <xsl:value-of select="."/>
                </a>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="."/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="tei:origin[not(. = '')]">
        <xsl:param name="sprache"/>
        <div>
            <span class="head">
                <xsl:choose>
                    <xsl:when test="$lang = 'de' ">Entstehung der Handschrift: </xsl:when>
                    <xsl:when test="$lang = 'en' ">Origin of the manuscript: </xsl:when>
                    <xsl:when test="$lang = 'fr' ">Origine du manuscrit: </xsl:when>
                    <xsl:when test="$lang = 'it' ">Origine del manoscritto: </xsl:when>
                    <xsl:otherwise><xsl:value-of select="name()"/></xsl:otherwise>
                </xsl:choose>
            </span>
            <xsl:choose>
                <xsl:when test="tei:p[2]">
                    <ul>
                        <xsl:apply-templates>
                            <xsl:with-param name="sprache" select="$lang"/>
                        </xsl:apply-templates>
                    </ul>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:apply-templates>
                        <xsl:with-param name="sprache" select="$lang"/>
                    </xsl:apply-templates>
                </xsl:otherwise>
            </xsl:choose>
        </div>
    </xsl:template>
    <xsl:template match="tei:p[not(. = '')]">
        <xsl:param name="sprache"/>
        <xsl:choose>
            <xsl:when test="(preceding-sibling::tei:p or following-sibling::tei:p) and      (parent::tei:binding or     parent::tei:condition or      parent::tei:decoDesc or      parent::tei:handNote or      parent::tei:origin or      parent::tei:provenance or      parent::tei:acquisition)">
                <li>
                    <xsl:apply-templates>
                        <xsl:with-param name="sprache" select="$lang"/>
                    </xsl:apply-templates>
                </li>
            </xsl:when>
            <xsl:when test="parent::tei:additions or      parent::tei:binding or      parent::tei:bindingDesc or      parent::tei:collation or      parent::tei:condition or      parent::tei:decoDesc or      parent::tei:foliation or      parent::tei:handDesc or      parent::tei:handNote or      parent::tei:layout or      parent::tei:musicNotation or      parent::tei:note or      parent::tei:origin or      parent::tei:provenance or      parent::tei:support or      parent::tei:acquisition">
                <xsl:if test="preceding-sibling::tei:p">
                    <br/>
                </xsl:if>
                <xsl:apply-templates>
                    <xsl:with-param name="sprache" select="$lang"/>
                </xsl:apply-templates>
            </xsl:when>
            <xsl:otherwise>
                <p>
                    <xsl:apply-templates>
                        <xsl:with-param name="sprache" select="$lang"/>
                    </xsl:apply-templates>
                </p>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="tei:pb[not(. = '')]">
        <span class="pb">
            <xsl:value-of select="@n"/>
        </span>
    </xsl:template>
    <xsl:template match="tei:provenance[not(. = '')]">
        <xsl:param name="sprache"/>
        <xsl:choose>
            <xsl:when test="preceding-sibling::tei:provenance or following-sibling::tei:provenance">
                <li>
                    <xsl:apply-templates>
                        <xsl:with-param name="sprache" select="$lang"/>
                    </xsl:apply-templates>
                </li>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates>
                    <xsl:with-param name="sprache" select="$lang"/>
                </xsl:apply-templates>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="tei:ref[not(. = '')]">
        <xsl:param name="sprache"/>
        <xsl:choose>
            <xsl:when test="starts-with(@target,'http') or starts-with(@target,'#') or starts-with(@target, 'mailto')">
                <a href="{@target}">
                    <xsl:apply-templates>
                        <xsl:with-param name="sprache" select="$lang"/>
                    </xsl:apply-templates>
                </a>
            </xsl:when>
            <xsl:when test="(@type='mss') and @cRef[starts-with(., 'mss_')][contains(substring-after(., 'mss_'), 'tei-msDesc_')]">
                <a href="?list=ms&amp;id={substring-before(substring-after(@cRef, 'mss_'), '_')}&amp;catalog={substring-after(@cRef, 'tei-msDesc_')}">
                    <xsl:apply-templates>
                        <xsl:with-param name="sprache" select="$lang"/>
                    </xsl:apply-templates>
                </a>
            </xsl:when>
            <xsl:when test="(@type='mss') and @cRef[starts-with(., 'mss_')]">
                <a href="?list=ms&amp;id={substring-after(@cRef, 'mss_')}">
                    <xsl:apply-templates>
                        <xsl:with-param name="sprache" select="$lang"/>
                    </xsl:apply-templates>
                </a>
            </xsl:when>
            <xsl:when test="(@type='mss') and @cRef[contains(., 'tei-msDesc_')]">
                <a href="?list=ms&amp;id={substring-before(@cRef, '_')}&amp;catalog={substring-after(@cRef, 'tei-msDesc_')}">
                    <xsl:apply-templates>
                        <xsl:with-param name="sprache" select="$lang"/>
                    </xsl:apply-templates>
                </a>
            </xsl:when>
            <xsl:when test="(@type='mss') and @cRef">
                <a href="?list=ms&amp;id={@cRef}">
                    <xsl:apply-templates>
                        <xsl:with-param name="sprache" select="$lang"/>
                    </xsl:apply-templates>
                </a>
            </xsl:when>
            <xsl:when test=" (@type = 'pdf') ">
                <a href="pdf/{ancestor::tei:msDesc/@xml:id}.pdf">
                    <xsl:apply-templates>
                        <xsl:with-param name="sprache" select="$lang"/>
                    </xsl:apply-templates>
                </a>
            </xsl:when>
            <xsl:when test="starts-with(.,'EBDB ')">
                <a>
                    <xsl:attribute name="target">
                        <xsl:text>_blank</xsl:text>
                    </xsl:attribute>
                    <xsl:attribute name="href">
                        <xsl:choose>
                            <xsl:when test="starts-with(substring-after(.,'EBDB '),'s') or        starts-with(substring-after(.,'EBDB '),'r') or        starts-with(substring-after(.,'EBDB '),'p')">
                                <xsl:value-of select="concat('http://db.hist-einband.de/?wz=',substring-after(.,'EBDB '))"/>
                            </xsl:when>
                            <xsl:when test="starts-with(substring-after(.,'EBDB '),'w')">
                                <xsl:value-of select="concat('http://db.hist-einband.de/?ws=',substring-after(.,'EBDB '))"/>
                            </xsl:when>
                        </xsl:choose>
                    </xsl:attribute>
                    <xsl:apply-templates>
                        <xsl:with-param name="sprache" select="$lang"/>
                    </xsl:apply-templates>
                </a>
            </xsl:when>
            <xsl:when test="starts-with(@cRef,'EBDB_')">
                <a>
                    <xsl:attribute name="target">
                        <xsl:text>_blank</xsl:text>
                    </xsl:attribute>
                    <xsl:attribute name="href">
                        <xsl:choose>
                            <xsl:when test="starts-with(substring-after(@cRef,'EBDB_'),'s') or        starts-with(substring-after(@cRef,'EBDB_'),'r') or        starts-with(substring-after(@cRef,'EBDB_'),'p')">
                                <xsl:value-of select="concat('http://db.hist-einband.de/?wz=',substring-after(@cRef,'EBDB_'))"/>
                            </xsl:when>
                            <xsl:when test="starts-with(substring-after(@cRef,'EBDB_'),'w')">
                                <xsl:value-of select="concat('http://db.hist-einband.de/?ws=',substring-after(@cRef,'EBDB_'))"/>
                            </xsl:when>
                        </xsl:choose>
                    </xsl:attribute>
                    <xsl:apply-templates>
                        <xsl:with-param name="sprache" select="$lang"/>
                    </xsl:apply-templates>
                </a>
            </xsl:when>
            <xsl:when test="(@type='biblical') and @cRef">
                <xsl:apply-templates/>
                <xsl:if test="(ancestor::tei:quote or ancestor::tei:incipit or ancestor::tei:explicit or ancestor::tei:index) and not(parent::note)">
                    <xsl:text disable-output-escaping="yes">&lt;span class="normal"&gt;</xsl:text>
                </xsl:if>
                <xsl:text> [</xsl:text>
                <a target="_blank">
                    <xsl:attribute name="href">
                        <xsl:value-of select="$cRef-biblical-start"/>
                        <xsl:value-of select="translate(translate(translate(@cRef,' ','+'),',',':'),'_',' ')"/>
                        <xsl:choose>
                            <xsl:when test="$lang = 'en' ">
                                <xsl:value-of select="$cRef-biblical-end_en"/>
                            </xsl:when>
                            <xsl:when test="$lang = 'fr' ">
                                <xsl:value-of select="$cRef-biblical-end_fr"/>
                            </xsl:when>
                            <xsl:when test="$lang = 'it' ">
                                <xsl:value-of select="$cRef-biblical-end_it"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="$cRef-biblical-end_de"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:attribute>
                    <xsl:value-of select="translate(translate(@cRef,' ','+'),'_',' ')"/>
                </a>
                <xsl:text>]</xsl:text>
                <xsl:if test="(ancestor::tei:quote or ancestor::tei:incipit or ancestor::tei:explicit or ancestor::tei:index) and not(parent::note)">
                    <xsl:text disable-output-escaping="yes">&lt;/span&gt;</xsl:text>
                </xsl:if>
            </xsl:when>
            <xsl:when test="(@type='repertorium')">
                <xsl:choose>
                    <xsl:when test="contains(.,'AH')">
					<!--a href="{substring-before(substring-after(.,'AH '),' Nr.')}"-->
                        <xsl:apply-templates>
                            <xsl:with-param name="sprache" select="$lang"/>
                        </xsl:apply-templates><!--/a-->
                    </xsl:when>
                    <xsl:when test="contains(.,'CAO')">
					<!--a href="{substring-after(.,'CAO ')}"-->
                        <xsl:apply-templates>
                            <xsl:with-param name="sprache" select="$lang"/>
                        </xsl:apply-templates><!--/a-->
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:apply-templates>
                            <xsl:with-param name="sprache" select="$lang"/>
                        </xsl:apply-templates>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates>
                    <xsl:with-param name="sprache" select="$lang"/>
                </xsl:apply-templates>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="tei:row[not(. = '')]">
        <xsl:param name="sprache"/>
        <xsl:element name="tr">
            <xsl:apply-templates>
                <xsl:with-param name="sprache" select="$lang"/>
            </xsl:apply-templates>
        </xsl:element>
    </xsl:template>
    <xsl:template match="tei:rs[not(. = '')]">
        <xsl:param name="sprache"/>
        <xsl:element name="span">
            <xsl:choose>
                <xsl:when test="(@type = 'author') and not(ancestor::tei:bibl)">
                    <xsl:attribute name="class">author</xsl:attribute>
                </xsl:when>
                <xsl:when test="(@type = 'author') and ancestor::tei:bibl">
                    <xsl:attribute name="class">biblAuthor</xsl:attribute>
                </xsl:when>
            </xsl:choose>
            <xsl:if test="@rend='supplied'">[</xsl:if>
            <xsl:apply-templates>
                <xsl:with-param name="sprache" select="$lang"/>
            </xsl:apply-templates>
            <xsl:if test="@rend='supplied' and not(following-sibling::tei:title[1][@rend='supplied'])">]</xsl:if>
        </xsl:element>
    </xsl:template>
    <xsl:template match="tei:rubric | tei:finalRubric">
        <xsl:param name="sprache"/>
        <xsl:choose>
            <xsl:when test="$rubricationSignOpener != '&gt;' ">
                <xsl:value-of select="$rubricationSignOpener"/>
                <span style="font-style:italic">
                    <xsl:apply-templates>
                        <xsl:with-param name="sprache" select="$lang"/>
                    </xsl:apply-templates>
                </span>
                <xsl:value-of select="$rubricationSignCloser"/>
            </xsl:when>
            <xsl:otherwise>
                <span class="smaller">
                    <xsl:text disable-output-escaping="no">&gt;</xsl:text>
                </span>
                <span style="font-style:italic">
                    <xsl:apply-templates>
                        <xsl:with-param name="sprache" select="$lang"/>
                    </xsl:apply-templates>
                </span>
                <span class="smaller">
                    <xsl:text disable-output-escaping="no">&lt;</xsl:text>
                </span>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="tei:secFol[not(. = '')]">
        <xsl:param name="sprache"/>
        <xsl:apply-templates>
            <xsl:with-param name="sprache" select="$lang"/>
        </xsl:apply-templates>
    </xsl:template>
    <xsl:template match="tei:sic[not(. = '')]">
        <xsl:param name="sprache"/>
        <xsl:apply-templates>
            <xsl:with-param name="sprache" select="$lang"/>
        </xsl:apply-templates>
        <span class="normal">
            <xsl:text>[sic]</xsl:text>
        </span>
    </xsl:template>
    <xsl:template match="tei:soCalled[not(. = '')]">
        <xsl:param name="sprache"/>
        <xsl:text disable-output-escaping="yes">"</xsl:text>
        <xsl:apply-templates>
            <xsl:with-param name="sprache" select="$lang"/>
        </xsl:apply-templates>
        <xsl:text disable-output-escaping="yes">"</xsl:text>
    </xsl:template>
    <xsl:template match="tei:summary[not(. = '')]">
        <xsl:apply-templates/>
        <xsl:if test="(count(following-sibling::tei:handNote) = 1)    or (count(following-sibling::tei:msItem) = 1)   or (count(following-sibling::tei:provenance) = 1)">
            <br/>
            <br/>
        </xsl:if>
    </xsl:template>
    <xsl:template match="tei:supplied[not(. = '')]">
        <span class="normal">[<xsl:apply-templates>
                <xsl:with-param name="sprache" select="$lang"/>
            </xsl:apply-templates>]</span>
    </xsl:template>
    <xsl:template match="tei:support[not(. = '')]">
        <xsl:param name="sprache"/>
        <div>
            <span class="head">
                <xsl:choose>
                    <xsl:when test="$lang = 'de' ">Beschreibstoff: </xsl:when>
                    <xsl:when test="$lang = 'en' ">Support: </xsl:when>
                    <xsl:when test="$lang = 'fr' ">Support: </xsl:when>
                    <xsl:when test="$lang = 'it' ">Supporto materiale: </xsl:when>
                    <xsl:otherwise><xsl:value-of select="name()"/></xsl:otherwise>
                </xsl:choose>
            </span>
            <xsl:apply-templates>
                <xsl:with-param name="sprache" select="$lang"/>
            </xsl:apply-templates>
        </div>
    </xsl:template>
    <xsl:template match="tei:surrogates[not(. = '')]">
        <xsl:param name="sprache"/>
        <div>
            <span class="head">
                <xsl:choose>
                    <xsl:when test="$lang = 'de' ">Sekundärformen: </xsl:when>
                    <xsl:when test="$lang = 'en' ">Surrogates: </xsl:when>
                    <xsl:when test="$lang = 'fr' ">Surrogates: </xsl:when>
                    <xsl:when test="$lang = 'it' ">Surrogates: </xsl:when>
                    <xsl:otherwise><xsl:value-of select="name()"/></xsl:otherwise>
                </xsl:choose>
            </span>
            <xsl:apply-templates>
                <xsl:with-param name="sprache" select="$lang"/>
            </xsl:apply-templates>
        </div>
    </xsl:template>
    <xsl:template match="tei:table[not(. = '')]">
        <xsl:param name="sprache"/>
        <xsl:element name="table">
            <xsl:attribute name="border">1</xsl:attribute>
            <xsl:apply-templates>
                <xsl:with-param name="sprache" select="$lang"/>
            </xsl:apply-templates>
        </xsl:element>
    </xsl:template>
    <xsl:template match="tei:term">
        <xsl:param name="sprache"/>
        <xsl:choose>
            <xsl:when test="parent::tei:index">
                <li>
                    <xsl:apply-templates>
                        <xsl:with-param name="sprache" select="$lang"/>
                    </xsl:apply-templates>
                </li>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates>
                    <xsl:with-param name="sprache" select="$lang"/>
                </xsl:apply-templates>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="tei:textLang[not(. = '')]">
        <xsl:param name="sprache"/>
        <xsl:if test="parent::tei:msItem and preceding-sibling::node()">
            <br/>
        </xsl:if>
        <span class="head">
            <xsl:choose>
                <xsl:when test="$lang = 'de' ">Hauptsprache: </xsl:when>
                <xsl:when test="$lang = 'en' ">Main language: </xsl:when>
                <xsl:when test="$lang = 'fr' ">Langue principale: </xsl:when>
                <xsl:when test="$lang = 'it' ">Lingua principale: </xsl:when>
                <xsl:otherwise><xsl:value-of select="name()"/></xsl:otherwise>
            </xsl:choose>
        </span>
        <xsl:apply-templates>
            <xsl:with-param name="sprache" select="$lang"/>
        </xsl:apply-templates>
        <xsl:if test="parent::tei:msItem and following-sibling::node()">
            <br/>
        </xsl:if>
    </xsl:template>
    <xsl:template match="tei:title[not(. = '')]">
        <xsl:param name="sprache"/>
        <xsl:element name="span">
            <xsl:choose>
                <xsl:when test="parent::tei:msItem">
                    <xsl:attribute name="class">msItemTitle</xsl:attribute>
                </xsl:when>
                <xsl:when test="parent::tei:bibl">
                    <xsl:attribute name="class">biblTitle</xsl:attribute>
                </xsl:when>
            </xsl:choose>
            <xsl:if test="@rend='supplied' and not(preceding-sibling::tei:author[1][@rend='supplied'])">[</xsl:if>
            <xsl:apply-templates>
                <xsl:with-param name="sprache" select="$lang"/>
            </xsl:apply-templates>
            <xsl:if test="@rend='supplied'">]</xsl:if>
        </xsl:element>
    </xsl:template>
    <xsl:template match="tei:unclear[not(. = '')]">
        <span class="normal">
            <xsl:apply-templates>
                <xsl:with-param name="sprache" select="$lang"/>
            </xsl:apply-templates>
            <xsl:text> (?)</xsl:text>
        </span>
    </xsl:template>

<!-- ===== Elemente für <text> ===== -->
    <xsl:template match="tei:div">
        <xsl:param name="sprache"/>
        <div>
            <xsl:apply-templates select="*[not(self::tei:index) and not(self::tei:msDesc)]">
                <xsl:with-param name="sprache" select="$lang"/>
            </xsl:apply-templates>
            <xsl:if test="descendant::tei:index">
                <ul>
                    <xsl:for-each-group select="descendant::tei:index" group-by="@indexName">
                        <xsl:sort select="@indexName"/>
                        <xsl:choose>
                            <xsl:when test="@indexName = 'chronologisch'">
                                <li>Datierte Handschriften (bis 1500)
                                    <ul>
                                        <xsl:apply-templates>
                                            <xsl:with-param name="sprache" select="$lang"/>
                                        </xsl:apply-templates>
                                    </ul>
                                </li>
                            </xsl:when>
                            <xsl:when test="@indexName = 'nasa'">
                                <li>Sachregister
                                    <ul>
                                        <xsl:apply-templates>
                                            <xsl:with-param name="sprache" select="$lang"/>
                                        </xsl:apply-templates>
                                    </ul>
                                </li>
                            </xsl:when>
                            <xsl:when test="@indexName = 'schreiber'">
                                <li>Schreiber
                                    <ul>
                                        <xsl:apply-templates>
                                            <xsl:with-param name="sprache" select="$lang"/>
                                        </xsl:apply-templates>
                                    </ul>
                                </li>
                            </xsl:when>
                            <xsl:when test="@indexName = 'vorbesitzer_koerperschaften'">
                                <li>Vorbesitzer Körperschaften
                                    <ul>
                                        <xsl:apply-templates>
                                            <xsl:with-param name="sprache" select="$lang"/>
                                        </xsl:apply-templates>
                                    </ul>
                                </li>
                            </xsl:when>
                            <xsl:when test="@indexName = 'vorbesitzer_koerperschaften'">
                                <li>Vorbesitzer Körperschaften
                                    <ul>
                                        <xsl:apply-templates>
                                            <xsl:with-param name="sprache" select="$lang"/>
                                        </xsl:apply-templates>
                                    </ul>
                                </li>
                            </xsl:when>
                            <xsl:when test="@indexName = 'vorbesitzer_personen'">
                                <li>Vorbesitzer Personen
                                    <ul>
                                        <xsl:apply-templates>
                                            <xsl:with-param name="sprache" select="$lang"/>
                                        </xsl:apply-templates>
                                    </ul>
                                </li>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:apply-templates>
                                    <xsl:with-param name="sprache" select="$lang"/>
                                </xsl:apply-templates>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:for-each-group>
                </ul>
            </xsl:if>
        </div>
    </xsl:template>


<!-- ===== just <apply-templates/> ===== -->
    <xsl:template match="tei:availability | tei:body | tei:layout | tei:objectDesc | tei:physDesc | tei:supportDesc | tei:text">
        <xsl:param name="sprache"/>
        <xsl:apply-templates select="*[not(self::tei:msDesc)]">
            <xsl:with-param name="sprache" select="$lang"/>
        </xsl:apply-templates>
    </xsl:template>
    <xsl:template match="tei:source" mode="source">
        <xsl:param name="sprache"/>
        <xsl:apply-templates>
            <xsl:with-param name="sprache" select="$lang"/>
        </xsl:apply-templates>
    </xsl:template>
    

<!-- ===== zu ignorierende Elemente ===== -->
    <xsl:template match="tei:adminInfo | tei:recordHist | tei:source"/>


<!-- ===== benannte Templates ===== -->
    <xsl:template name="attr-rend-verarbeiten">
        <xsl:param name="value"/>
        <xsl:attribute name="style">
            <xsl:if test="$value = 'sup' ">vertical-align:super;font-size:80%;margin-left:2px;</xsl:if>
            <xsl:if test=" contains($value,'small-caps') ">font-variant:small-caps;</xsl:if>
            <xsl:if test=" contains($value,'italic')     or (local-name()='incipit')     or (local-name()='explicit')     or (local-name()='quote')">font-style:italic;</xsl:if>
            <xsl:if test=" contains($value,'underline') ">text-decoration:underline;</xsl:if>
            <xsl:if test=" contains($value,'bold') ">font-weight:bold;</xsl:if>
        </xsl:attribute>
        <xsl:if test="contains($value,'dots-before')">...</xsl:if>
    </xsl:template>
    <xsl:template name="locus-verarbeiten">
        <xsl:param name="attribute"/>
        <xsl:param name="content"/>
        <xsl:variable name="xmlid">
            <xsl:choose>
                <xsl:when test="ancestor::tei:msDesc/@xml:id">
                    <xsl:value-of select="substring-before(substring-after(ancestor::tei:msDesc/@xml:id, concat($collection, '_')), '_tei-msDesc')"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="substring-before(substring-after(ancestor::tei:TEI/@xml:id, concat($collection, '_')), '_tei-msDesc')"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="catalog">
            <xsl:choose>
                <xsl:when test="substring-after(ancestor-or-self::tei:TEI/@xml:id, 'tei-msDesc') ne ''">
                    <xsl:value-of select="concat('&amp;catalog=', substring-after(ancestor-or-self::tei:TEI/@xml:id, 'tei-msDesc_'))"/>
                </xsl:when>
                <xsl:otherwise/>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="facsimile">
            <xsl:choose>
                <xsl:when test="ancestor-or-self::tei:TEI/tei:facsimile">
                    <xsl:copy-of select="ancestor-or-self::tei:TEI/tei:facsimile"/>
                </xsl:when>
                <xsl:when test="doc-available('tei-msDesc.xml') and doc('tei-msDesc.xml')//tei:facsimile">
                    <xsl:copy-of select="doc('tei-msDesc.xml')//tei:facsimile"/>
                </xsl:when>
                <xsl:when test="doc-available($facsimileData)">
                    <xsl:copy-of select="doc($facsimileData)"/>
                </xsl:when>
                <xsl:when test="doc-available(concat($server, $collection, '/', $xmlid, '/', $facsimileData))">
                    <xsl:copy-of select="doc(concat($server, $collection, '/', $xmlid, '/', $facsimileData))"/>
                </xsl:when>
            </xsl:choose>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="$facsimile/*:facsimile/*:graphic/@n[.=$attribute]">
                <a href="?list=ms&amp;id={$xmlid}{$catalog}&amp;image={substring-after($facsimile/*:facsimile/*:graphic[@n=$attribute]/@xml:id, concat($xmlid,'_'))}">
                    <xsl:value-of select="$content"/>
                </a>
            </xsl:when>
            <xsl:when test="$facsimile/*:facsimile/*:graphic/@n[.=substring-before($attribute,'a')]">
                <a href="?list=ms&amp;id={$xmlid}{$catalog}&amp;image={substring-after($facsimile/*:facsimile/*:graphic[@n=substring-before($attribute,'a')]/@xml:id, concat($xmlid,'_'))}">
                    <xsl:value-of select="$content"/>
                </a>
            </xsl:when>
            <xsl:when test="$facsimile/*:facsimile/*:graphic/@n[.=substring-before($attribute,'b')]">
                <a href="?list=ms&amp;id={$xmlid}{$catalog}&amp;image={substring-after($facsimile/*:facsimile/*:graphic[@n=substring-before($attribute,'b')]/@xml:id, concat($xmlid,'_'))}">
                    <xsl:value-of select="$content"/>
                </a>
            </xsl:when>
            <xsl:when test="$facsimile/*:facsimile/*:graphic/@n[.=substring-before($attribute,'c')]">
                <a href="?list=ms&amp;id={$xmlid}{$catalog}&amp;image={substring-after($facsimile/*:facsimile/*:graphic[@n=substring-before($attribute,'c')]/@xml:id, concat($xmlid,'_'))}">
                    <xsl:value-of select="$content"/>
                </a>
            </xsl:when>
            <xsl:when test="$facsimile/*:facsimile/*:graphic/@n[.=substring-before($attribute,'d')]">
                <a href="?list=ms&amp;id={$xmlid}{$catalog}&amp;image={substring-after($facsimile/*:facsimile/*:graphic[@n=substring-before($attribute,'d')]/@xml:id, concat($xmlid,'_'))}">
                    <xsl:value-of select="$content"/>
                </a>
            </xsl:when>
            <xsl:when test="$facsimile/*:facsimile/*:graphic/@n[.=concat($attribute,'r')]">
                <a href="?list=ms&amp;id={$xmlid}{$catalog}&amp;image={substring-after($facsimile/*:facsimile/*:graphic[@n=concat($attribute,'r')]/@xml:id, concat($xmlid,'_'))}">
                    <xsl:value-of select="$content"/>
                </a>
            </xsl:when>
            <xsl:when test="$facsimile/*:facsimile/*:graphic/@n[.=concat($attribute,'v')]">
                <a href="?list=ms&amp;id={$xmlid}{$catalog}&amp;image={substring-after($facsimile/*:facsimile/*:graphic[@n=concat($attribute,'v')]/@xml:id, concat($xmlid,'_'))}">
                    <xsl:value-of select="$content"/>
                </a>
            </xsl:when>
            <xsl:when test="$attribute = //*:facsimile/*:graphic/@n">
                <a href="{$xmlid}/{$startfile}{$imageParameter}{substring-after(//*:facsimile/*:graphic[@n=$attribute]/@xml:id, concat(substring-before(substring-after(//tei:msDesc/@xml:id, 'mss_'), '_tei-msDesc'), '_'))}">
                    <xsl:value-of select="$attribute"/>
                </a>
            </xsl:when>
            <xsl:when test="@rend">
                <span>
                    <xsl:call-template name="attr-rend-verarbeiten">
                        <xsl:with-param name="value" select="@rend"/>
                    </xsl:call-template>
                    <xsl:value-of select="$content"/>
                </span>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$content"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="element-name">
        <xsl:param name="name"/>
        <xsl:param name="sprache"/>
        <span class="head">
            <xsl:choose>
                <xsl:when test=" $name = 'altIdentifier' ">
                    <xsl:choose>
                        <xsl:when test=" @type = 'AlternativerBibliotheksname' ">
                            <xsl:choose>
                                <xsl:when test="$lang = 'de' ">Alternativer Bibliotheksname: </xsl:when>
                                <xsl:when test="$lang = 'en' ">Alternative library name: </xsl:when>
                                <xsl:when test="$lang = 'fr' ">Nom alternatif de la bibliothèque: </xsl:when>
                                <xsl:when test="$lang = 'it' ">Nome alternativo della biblioteca: </xsl:when>
                                <xsl:otherwise><xsl:value-of select="@type"/></xsl:otherwise>
                            </xsl:choose>
                        </xsl:when>
                        <xsl:when test=" @type = 'alternative' ">
                            <xsl:choose>
                                <xsl:when test="$lang = 'de' ">Alternative Schreibung: </xsl:when>
                                <xsl:when test="$lang = 'en' ">Alternative writing: </xsl:when>
                                <xsl:when test="$lang = 'fr' ">Alternative writing: </xsl:when>
                                <xsl:when test="$lang = 'it' ">Alternative writing: </xsl:when>
                                <xsl:otherwise><xsl:value-of select="@type"/></xsl:otherwise>
                            </xsl:choose>
                        </xsl:when>
                        <xsl:when test=" @type = 'catalog' ">
                            <xsl:choose>
                                <xsl:when test="$lang = 'de' ">Katalognummer: </xsl:when>
                                <xsl:when test="$lang = 'en' ">Catalogue number: </xsl:when>
                                <xsl:when test="$lang = 'fr' ">Catalogue number: </xsl:when>
                                <xsl:when test="$lang = 'it' ">Catalogue number: </xsl:when>
                                <xsl:otherwise><xsl:value-of select="@type"/></xsl:otherwise>
                            </xsl:choose>
                        </xsl:when>
                        <xsl:when test=" @type = 'erroneous' ">
                            <xsl:choose>
                                <xsl:when test="$lang = 'de' ">Fehlerhafte Signatur: </xsl:when>
                                <xsl:when test="$lang = 'en' ">Erroneous shelfmark: </xsl:when>
                                <xsl:when test="$lang = 'fr' ">Erronée Cote: </xsl:when>
                                <xsl:when test="$lang = 'it' ">Segnatura difettosa: </xsl:when>
                                <xsl:otherwise><xsl:value-of select="@type"/></xsl:otherwise>
                            </xsl:choose>
                        </xsl:when>
                        <xsl:when test="( @type = 'former' ) or (not(@type))">
                            <xsl:choose>
                                <xsl:when test="$lang = 'de' ">Frühere Signatur: </xsl:when>
                                <xsl:when test="$lang = 'en' ">Former shelfmark: </xsl:when>
                                <xsl:when test="$lang = 'fr' ">Ancienne Cote: </xsl:when>
                                <xsl:when test="$lang = 'it' ">Segnatura precedente: </xsl:when>
                                <xsl:otherwise><xsl:value-of select="@type"/></xsl:otherwise>
                            </xsl:choose>
                        </xsl:when>
                        <xsl:when test=" @type = 'group' ">
                            <xsl:choose>
                                <xsl:when test="$lang = 'de' ">Überlieferung: </xsl:when>
                                <xsl:when test="$lang = 'en' ">Transmission: </xsl:when>
                                <xsl:when test="$lang = 'fr' ">Transmission: </xsl:when>
                                <xsl:when test="$lang = 'it' ">Transmission: </xsl:when>
                                <xsl:otherwise><xsl:value-of select="@type"/></xsl:otherwise>
                            </xsl:choose>
                        </xsl:when>
                    </xsl:choose>
                </xsl:when>
                <xsl:when test=" $name = 'msName' ">
                    <xsl:choose>
                        <xsl:when test="$lang = 'de' ">Alternative Bezeichnung: </xsl:when>
                        <xsl:when test="$lang = 'en' ">Alternative name: </xsl:when>
                        <xsl:when test="$lang = 'fr' ">Nom alternatif: </xsl:when>
                        <xsl:when test="$lang = 'it' ">Nome alternativo: </xsl:when>
                        <xsl:otherwise><xsl:value-of select="@type"/></xsl:otherwise>
                    </xsl:choose>
                </xsl:when>
            </xsl:choose>
        </span>
    </xsl:template>
    <xsl:template match="tei:back"/>
</xsl:stylesheet>