<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0">
    
    <xsl:param name="urn-resolver">http://nbn-resolving.de/urn/resolver.pl?urn=</xsl:param>
    <xsl:param name="urn-base">urn:nbn:</xsl:param>
    <xsl:param name="urn-country">de</xsl:param>
    <xsl:param name="urn-network">gbv</xsl:param>
    <xsl:param name="urn-library">23</xsl:param>
    <xsl:param name="collection">mss</xsl:param>
    <!-- Ende URN-Bestandteile -->
    <xsl:param name="settlement">Wolfenbüttel</xsl:param>
    <!-- Webserver für Digitalisierungen -->
    <xsl:param name="server">http://diglib.hab.de/</xsl:param>
    <xsl:param name="server-path">mss/</xsl:param>
    <xsl:param name="xmlid">
        <xsl:value-of
            select="replace(replace(replace(replace(replace(replace(replace(translate(translate(lower-case(//tei:msDesc/tei:msIdentifier/tei:idno),'.',''),' ','-'),'fol','2f'),'4to','4f'),'8vo','8f'),'12mo','12f'),'α','alpha'),'β','beta'),'—','--')"
        />
    </xsl:param>
    <xsl:param name="abfrage">/start.htm?image=</xsl:param>
    <!-- Ende Webserver für Digitalisierungen -->
    <!-- Verknüpfung zur Literatur (OPAC, Literaturdatenbank, etc.) -->
    <xsl:param name="Verbund">hab</xsl:param>
    <xsl:param name="Suchfeld">ppn</xsl:param>
    <xsl:param name="OPAC">http://opac.lbs-braunschweig.gbv.de/DB=2/CMD?ACT=SRCHA&amp;TRM=PPN+</xsl:param>
    <!-- GBV: http://gso.gbv.de/DB=2.1/CMD?ACT=SRCHA&TRM=ppn+ -->
    <!--d-nb: http://dispatch.opac.ddb.de/DB=4.1/PPN?PPN=-->
    <!-- $literaturDB - mögliche Werte: eine URL der Datenbank oder leer lassen -->

    <!--http://194.95.134.232/mssdoku/find.php?urG=CLA%20&urS=-->
    <!-- Ende Verknüpfung zur Literatur -->
    <!-- Nachweis des Copyright -->
    <xsl:param name="availability">restricted</xsl:param>
    <xsl:param name="availabilityDesc">http://diglib.hab.de/?link=012</xsl:param>
    <!-- mögliche Verknüpfungen mit Ressourcen für kanonische Zitate: Bibel, MGH, etc. -->
    <xsl:param name="cRef-biblical-start">http://www.biblija.net/biblija.cgi?m=</xsl:param>
    <xsl:param name="cRef-biblical-end">&amp;id8=1&amp;id12=1&amp;set=1&amp;l=en</xsl:param>
    <!-- auch: http://www.bibelgesellschaft.de/channel.php?channel=35&INPUT=; ohne cRef-end -->
    <!-- Ende mögliche Verknüpfungen mit Ressourcen für kanonische Zitate -->
    <xsl:param name="css-file">../styles/druck.css</xsl:param>
    <xsl:param name="Status">fertig</xsl:param>
    <!-- mögliche Werte: vorlaeufig/fertig -->
    <!-- für alle folgenden Parameter mögliche Werte: yes/no -->
    <xsl:param name="alleElementeAnzeigen">yes</xsl:param>
    <xsl:param name="EinzeldateienAusgeben">yes</xsl:param>
    <xsl:param name="mehrereKatalogisatePublizieren">no</xsl:param>
    <xsl:param name="msPartUeberschriftAnzeigen">no</xsl:param>
    <xsl:param name="registerAnzeigen">yes</xsl:param>
    <xsl:param name="abgekuerzteLiteraturAuflisten">yes</xsl:param>
    <xsl:param name="Autorname">no</xsl:param>
    
    <!-- Parameter für die Katalogausgabe -->
    <xsl:param name="media"><!-- mögliche Werte: print, print-offline, web; default: print --></xsl:param>
    <xsl:param name="rend"><!-- mögliche Werte: condensed, normal; default: condensed --></xsl:param>
    <xsl:param name="catalogueType"><!-- mögliche Werte: text, illum; default: text --></xsl:param>
    <xsl:param name="status"><!-- mögliche Werte: vorlaeufig/fertig; default: vorlaeufig --></xsl:param>
    <xsl:param name="mode"><!-- mögliche Werte: test/publish; default: publish --></xsl:param>
    <xsl:param name="pathFromHere">../html/</xsl:param>
    <!-- Ende Parameter für die Katalogausgabe -->
    <!-- Parameter für Digitalisate -->
    <xsl:param name="repository_short"><xsl:text>HAB</xsl:text></xsl:param>
    <!--<xsl:param name="xmlid"><xsl:value-of select="replace(replace(replace(replace(replace(replace(replace(translate(translate(lower-case(//tei:msDesc/tei:msIdentifier/tei:idno),'.',''),' ','-'),'fol','2f'),'4to','4f'),'8vo','8f'),'12mo','12f'),'&#x03B1;','alpha'),'&#x03B2;','beta'),'&#x2014;','-')"/></xsl:param>--><!-- '&#x2014;','-' ist zu ersetzen durch Doppelbindestrich -->
    <xsl:param name="Katalogisat-Postfix"><xsl:text></xsl:text></xsl:param>
    <!-- Ende Webserver für Digitalisierungen -->
    <!-- zu ignorierende Bestandteile der Signatur -->
    <xsl:param name="ignoreInSettlement"><!-- z.B. Wolfenbüttel --></xsl:param>
    <xsl:param name="ignoreInInstitution"><!-- z.B. Universität xy --></xsl:param>
    <xsl:param name="ignoreInRepository"><!-- z.B. Herzog August Bibliothek --></xsl:param>
    <xsl:param name="ignoreInCollection"><!-- z.B. Helmstedter Handschriften --></xsl:param>
    <xsl:param name="ignoreInIdno"><!-- z.B. Cod. Guelf. --></xsl:param>
    <!-- Ende zu ignorierende Bestandteile der Signatur -->
    <!-- Verknüpfung zur Repertorien und Datenbanken -->
    <xsl:param name="searchfield">opac</xsl:param>
    <!-- $literaturDB - mögliche Werte: eine URL der Datenbank oder leer lassen -->
    <xsl:param name="literaturDB"></xsl:param><!--http://194.95.134.232/mssdoku/find.php?urG=CLA%20&amp;urS=-->
    <xsl:param name="listBibl"><!-- z.B. listBibl.xml --></xsl:param>
    <xsl:param name="listOrg"> <!-- z.B. listOrg.xml --></xsl:param>
    <xsl:param name="listPerson"><!-- z.B. listPerson.xml --></xsl:param>
    <xsl:param name="listPlace"><!-- z.B. listPlace.xml --></xsl:param>
    <xsl:param name="regex">(\d*)(\D)?-(\D*)-?(\d°)?</xsl:param>
    <!-- Ende Verknüpfung zur Literatur -->
    <xsl:param name="cssFile">http://diglib.hab.de/rules/styles/mss/TEI-P5-to-Print/druck.css</xsl:param>
    <xsl:param name="Trennzeichen"> &#x2014; </xsl:param>
    <xsl:param name="Datum"/>
    <!-- für alle folgenden Parameter mögliche Werte: yes/no -->
    <xsl:param name="createShortlist">no</xsl:param>
    <xsl:param name="fieldIntro">yes</xsl:param>
    <xsl:param name="listAbbreviatedTitles">yes</xsl:param>
    <xsl:param name="listMssSeperately">no</xsl:param>
    <xsl:param name="publishSingleFiles">no</xsl:param>
    <xsl:param name="showAllElements">yes</xsl:param>
    <xsl:param name="showAuthorname">no</xsl:param>
    <xsl:param name="showMsPartTitles">no</xsl:param>
    <!-- mögliche Werte: yes/no/only/separately -->
    <xsl:param name="showIndex"><!-- mögliche Werte: yes/no/only/separately -->no</xsl:param>
    
</xsl:stylesheet>
