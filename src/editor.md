Detta är ett exempel på hur du använder Markdown. Gör ändringar i textfältet och
se hur det kommer att se ut på webbsidan i förhandsgranskingen. Du kan spara ner
texten till din dator genom "<i class="fa fa-solid fa-download"></i>"-knappen högst upp på sidan.

Rubriker skapas genom att sätta ett eller flera `#`-tecken följt av ett mellanrum framför din rubriktext; antalet `#` anger rubriknivå (använd inte första nivå, sidtiteln är nivå ett):


## Grunder

Text kan göras _kursiv_ och __fet__.

En tom rad skapar en ny paragraf,
enkla radbrytningar visas inte men en radbrytning kan tvingas genom  
att föregå radbrytningen med två mellanslag. En HTML tag för radbrytning<br>
är lättare att se.

> Blockcitat med pilar har samma regler  
> för radbrytningar.
> <footer>—HTML krävs för att attribuera, <cite>författaren 2024</cite></footer>

Text kan `markeras som kod` eller göras till kodblock:
```
här ger radbrytning en ny rad
och *specialtecken* har __ingen__ effekt<br>
```

Specialtecken kan göras "normala" genom escape-tecknet `\`: \*inte kursiv\*, \<inte html\>.

Här gör vi en horisontell linje av minst tre `-`, men raden ovanför linjen måste vara tom, annars blir det en nivå 2 rubrik!

---


### Länkar och bilder

Text kan [länkas](https://dalregementetsif.se "titel som visas när man för musen över länken")
och bilder kan infogas ![alt-text (kan utelämnas) visas när bild inte kan visas](https://dalregementetsif.se/img/dalreg-logo-100.webp "bild kan också ha en titel").

Bilder kan också användas som länkar [![](https://faktningfalun.se/img/dalreg-logo-100.webp)](https://dalregementetsif.se).

[Den här länken](https://faktningfalun.se) har ingen titeltext, och den här ![bilden](https://faktningfalun.se/img/ingenting) finns inte.


### Listor och tabeller

Punktlistor skapas med `-` eller `*`, och numrerade listor genom `1.` osv.:

* en listpost
* en till listpost

Tabeller kan skapas:

| Rubrik | En annan rubrik |
|--------|-----------------|
| fält 1 | text            |
| fält 2 | mellanslagen spelar ingen roll |
|fält 3|som vi ser|


## Avancerat

Osynliga kommentarer kan skapas så här, viktigt med tom rad innan:

[//]: # (skriv din kommentar här)

Sådana kommentarer kommer bara synas i Markdown-filen, vanliga <!-- HTML kommentarer --> blir synliga i källkoden.
Kommentarer är bra för att komma ihåg saker eller informera nästa person som vill ändra något.

Om det ska gå att länka direkt till en viss rubrik på sidan måste vi använda HTML för att skapa rubriken och sätta ett, för sidan, unikt ID:
<h2 id="rubrik2">rubrik 2</h2>
<h3 id="rubrik3">rubrik 3</h3>

För att länka internt på sidan kan vi då göra [till rubrik 2](#rubrik2) eller [till rubrik 3](#rubrik3); från en annan sida måste vi länka mot `https://url-till-sidan#rubrik2` eller `https://url-till-sidan#rubrik3`.
