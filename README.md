# dalregementetsif.se
Projektet använder [make](https://man7.org/linux/man-pages/man1/make.1.html) för
att bygga ihop webbplatsen och kräver cwebp samt vanliga POSIX och GNU verktyg.
Målsystemet är [Alpine Linux](https://www.alpinelinux.org/).

## Sidor
För att en sida i webbplatsen ska byggas krävs att både `src/sidnamn.html` och
`src/sidnamn.env` existerar. För att sidan ska bli nåbar genom navigationen
måste `templates/header.html` uppdateras med korresponderande `<li>`, sök
`id="menu"`.

### .env
```
PAGE_TITLE="Exempeltitel"
BANNER="banner-exempel"
SIDEIMAGE="side-exempel"
DESCRIPTION="Kort beskrivning av sidans innehåll för SEO"
KEYWORDS="nyckelord, mellan, komman"
```
Nyckelorden från `KEYWORDS` är i tillägg till de generella nyckelord definierade
i `Makefile`. `PAGE_TITLE` i exemplet ovan kommer resultera i
`<title>Exempeltitel · Fäktning/M5K i Falun</title>` och `<h1>Exempeltitel<h1>`.
Om `BANNER` eller `SIDEIMAGE` inte uppges kommer respektive element inte skapas;
saknas bildfilen kommer elementet skapas och ta en viss plats men vara osynligt.

## Bilder
Bilder måste vara PNG-filer. `webp.sh` genererar automatiskt WEBP-filer från
dessa när sidan byggs. Alla PNG-filer kommer att resultera i en respektive
WEBP-fil `<basnamn>.webp` i tillägg till specialfallen definierade nedan.

### Banners
En banner-bild måste vara 1440 pixlar bred och 500 pixlar hög och innehålla
`banner` i filnamnet. Följande storlekar kommer genereras som
`<basnamn>-<bredd>x<höjd>.webp`:

* 1440x500
* 1024x356
* 768x267
* 300x104

En WEBP-fil i storleken 474x342 kommer också genereras från en urskärning av
originalfilen.

### Sidbild
En sidbild måste vara 200 pixlar bred och 413 pixlar hög och innehålla `side` i
filnamnet.  Sidbilden genereras som `<basnamn>-200x413.webp`

## Dynamiskt innehåll
"Sidorna" för filer och mötesprotokoll är katalogförteckningar automatiskt
skapade av Nginx från filsystemet på servern. Modulen fancyindex används för att
skapa katalogförteckningarna i samma design som resten av webbplatsen. Filerna
synkas till servern från föreningens Dropbox genom rclone; mötesprotokoll hämtas
från `03 Sekreteraren/Styrelsemöten`, övriga filer från `14 WWW/Filer`.

Sidor kan ges dynamiskt innehåll genom filer synkade till servern.
[inosync](https://github.com/Dalregementets-IF/inosync) ges argument som
beskriver en action, inputfil, och outputfil: programmet övervakar filerna och
vid filändring tar data från inputfil och modifierar outputfil enligt given
action. Inosync kräver att HTML-kommentarerna `<!-- INOSYNC BEGIN -->` och
`<!-- INOSYNC END -->` finns som separata rader i outputfilen:
Servern hanterar för närvarande:

* styrelse.html: `<table>` där `<tr>` element skapas från TSV fil.
* index.html: promobox `<div>` som växlas "av/på" beroende på om PDF finns.
* tavlingar.html: lista på tävlingar med info som skapas från TSV fil.
* sektionssidor: innehåll konverteras från markdown filer.
