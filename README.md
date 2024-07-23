# dalregementetsif.se
Projektet använder [make](https://man7.org/linux/man-pages/man1/make.1.html) för
att bygga ihop webbplatsen och kräver cwebp samt vanliga POSIX och GNU verktyg.
Målsystemet är [Alpine Linux](https://www.alpinelinux.org/).

## Sidor
En sida definieras i `src` som en fil likt `sidnamn.txt`, och byggs som
`sidnamn.html`. För att sidan ska bli nåbar genom navigationen måste
`templates/header.html` uppdateras med korresponderande `<li>`, sök
`id="menu"`. Exempel på format:

```
title: Exempeltitel
description: Kort beskrivning av sidans innehåll för SEO
keywords: nyckelord, mellan, komman
sideimages: side-exempel qr-exempel
flags: banner notitle nostatic

HTML innehåll för sidan
```

Nyckelorden från `keywords` är i tillägg till de generella nyckelord definierade
i `Makefile`.

`title` i exemplet ovan kommer resultera i
`<title>Exempeltitel · Dalregementets IF</title>` och `<h1>Exempeltitel<h1>`.

`sideimages` definierar noll eller fler bilder som på större skärmar läggs till
höger av innehållet och minskar dess horisontella utrymme; på mindre skärmar
flyttas bilderna till under innehållet istället. Om `sideimages` lämnas tom
kommer innehållet använda fullt horisontellt utrymme. Basfiler för `sideimages`
måste matcha `side-*.png` eller `qr-*.png`.

`flags` definierar noll eller fler flaggor som ska användas när sidan byggs.
Tillgängliga flaggor är:

* banner: lägg en bannerbild överst på sidan, basfilen för banner måste matcha
`banner-<sidnamn>.png`. Om bildfil saknas kommer banner vara osynlig men ta upp
några få pixlars utrymme.
* notitle: lägg inte till strängen från `title` i `<title>`. Används för index.
* nostatic: allt innehåll är dynamiskt, ignorerar innehåll från textfilen.

## Bilder
Bilder måste vara PNG-filer. `webp.sh` genererar automatiskt WEBP-filer från
dessa när sidan byggs. Alla PNG-filer kommer att resultera i en respektive
WEBP-fil `<basnamn>.webp` i tillägg till specialfallen definierade nedan.

### Banners
En banner-bild måste vara 1440 pixlar bred och 500 pixlar hög och filnamnet
måste matcha `banner-<sida>.png` Följande storlekar kommer genereras som
`<basnamn>-<bredd>x<höjd>.webp`:

* 1440x500
* 1024x356
* 768x267
* 300x104

En WEBP-fil i storleken 474x342 kommer också genereras från en centrerad
urskärning av originalfilen.

### Sidbild och QR-kod
En sidbild eller QR-kod måste matcha `side-*.png` eller `qr-*.png`. Bild
genereras skalad till 200 pixlars bredd som `<basnamn>-200.webp`.

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
* forening.html: innehåll konverteras från markdown fil.
