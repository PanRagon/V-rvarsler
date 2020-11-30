
Kandidatnummer 10042

## Teknisk
Jeg har brukt Xcode versjon 11.6, jeg bruker Swift 5 og jeg har targetted iOS 13.6, med MacOS og iPadOS disabled.

## Utforming
Jeg har underveis i prosjektet prøvd å vise fram gode designprinsipper underveis, og spesielt MVC-modellen. Jeg har basert meg på forelesningsmateriale og kurs underveis, og jeg har prøvd å få til abstraksjon der det gir mening, slik som i API-kallene og i LocationData-modellen (jeg kommer tilbake til hvorfor denne ikke er helt ideel, men veldig tilstrekkelig for oppgaven). Oppgavene baserer seg på bruk av lokasjonsdata fra brukeren, jeg har tatt høyde for at disse dataene kan skrus av av brukeren, og i de tilfellene er værmeldinger basert på HK (men pin-funksjonalitet på kart fungerer fortsatt)

## Oppgaver
Jeg har fullført alle oppgavene med alle krav fram til oppgave 4. Fra oppgave 5 har jeg også implementert "Sist Oppdatert" teksten og sol-animasjoner.

## Værmelding
Denne siden er lagd med TableView slik oppgaven beskriver og fetcher sine data fra WeatherAPI. Lokasjonen som brukes er basert på LocationData som muteres av KartViewet når den er i bruk, og vil hellers hente data for HK. Det er litt ulikt design på cellene i referansebildet fra oppgaven, men jeg har i hvert fall tatt høyde for at den nederste labelen på venstre side vil være på linje med den første til høyre, og at den nederste cellen på høyre siden vil være blank der ingen precipitation informasjon finnes. 

## Kart
Kartet bruker MapKit view og implementerer en ContainerView for viewet med værinformasjon for brukeren. Pin-funksjonen vil fungere selv om brukeren har skrudd av deling av posisjonsdata. Jeg har tolket oppgave 3 som at viewet under kartet kan ha sin egen kontroller, og har derfor brukt en containerview med egen ViewController koblet til MapViewController. En annen tolkning av oppgaven kan være å kun lage et eget view uten view controller, koblet til MapViewControlleren med en IBOutlet, som implementerer WeatherAPIDelegate og fetcher data. Dette blir i mine øyne litt problematisk fra et softwaredesignutgangspunkt siden du da har en View som fetcher og manipulerer data, ikke en Controller, som jeg tolker som et brudd på MVC-modellen.
Kommunikasjon mellom Map og Container skjer gjennom en NotificationCenter, som gjør at data kan sendes og mottas frivillig av de klassene som implementerer en observer eller poster til den. En annen måte å kommunisere på er segues som brukes gjerne i parent/child-konteksten, jeg fant imidlertidig ingen løsning som var like uproblematisk som NotificationCenter når det gjaldt å ha en stream med info gående hele tiden, de fleste implementasjoner jeg så brukte den mer for en gangs overføringer. 

## Hjem
Hjemsiden har kun 3 elementer og persisterer data med UserDefaults. Forskjellen mellom UserDefaults og CoreData er at UserDefaults er en ustrukurert dictionary, mens CoreData gir tilgang på mer relasjonell lagring. Et dictionary var mer enn nok i konteksten jeg brukte det, jeg ønsker kun tilgang på litt dato og et symbol. Hjem tar i bruk samme WeatherAPI som Værmeldingen og Kart-siden, og implementerer LocationManager på samme måte som kartsiden. Merk at jeg har forstått det som viktig at de må ha vær sin og ikke bruke samme lokasjonsdata, da værmeldingen skal spesifikt vise HK fram til brukeren har tykker på kartet - selv om jeg queryer denne informasjonen allerede i hjem.

## Modeller
Jeg har prøvd å bruke meningsfulle modeller og datastrukturer for innholdet som skal vises og passeres. APIet blir hentet ut fra WeatherAPI, og decoded med WeatherData. WeatherModel inneholder all dataen jeg tar i bruk fra APIet, og brukes av controllere som konsumerer APIet. Den er beregnet til Værmelding siden og inneholder noe overflødig informasjon for Kart Kontaineren og Hjemmesiden, men dette er såpass irrelevant fra et minneperspektiv at jeg har forholdt den såpass abstrakt. WeatherData er også satt opp til å kun fiske ut data som skal brukes i modellen, så en del data vil bli filtert ut av kallet her.
I WeatherModellen har jeg også tatt gjort noen antagelser med symboler og teksten, jeg har enten sol eller paraply på hjemsiden slik spesifisert, på kartsiden står det ikke konkret men her bruker jeg symboler basert på hvilken kategori symbolcoden er i (Regn, overskyet, sol), og i Værmeldingen oversetter jeg hele koden og printer ut, da det var usikkert hvor presist denne burde være. Jeg tenkte jo mer presis data jo bedre, og har verifisert at selv de lengste strengene vil passe på alle skjermer.
For lagring av brukerenslokasjons data har jeg brukt en statisk struct som defaulter til HK om brukerenslokasjon fra kartet ikke har blitt hentet inn, jeg har tolket det som at dette kanskje kan være en slags default verdi dersom lokasjonsdata ikke kommer inn, jeg mener i hvert fall dette er rimelig fra et designperspektiv så appen ikke er helt 'død' dersom brukeren ikke gir lokasjonsdata. Det er verdt å nevne at denne statiske structen er en Singleton, som er en global verdi og ofte blir ansett som en anti-pattern og bør brukes sparsommelig. Dette har jeg vært klar over, men siden lokasjonsdata og HK-data er noe jeg har brukt gjennom appen så virker det OK å ha en litt mindre trygg struktur på denne som veier opp med fleksibilitet, så jeg har selv vurdert opp på denne biten. I resten av appen har jeg begrenset tilgengelighet av data til der det trengs ved bruk av Delegate protokoller og NotificationCenter.

## Design
Alt grensesnitt er satt opp via Storyboard, jeg lager ingenting i grensesnittet programatisk men heller redigerer det som er tegnet opp i Storyboard filer. Dette er et pattern som gjør det mer oversiktlig å forstå grensesnittet enn om man blander programatisk generering og storyboards. Jeg vurderte å lage alt med SwiftUI, et designparadigme jeg egentlig foretrekker siden jeg har mer web- og kryssplattformerfaring fra før, men kom fram til at det var litt tidlig og det er fort mye vanskeligere å finne gode ressurser på det. Jeg har ikke vektlagd design utover at alt skal renderes bra på alle skjermer (untatt et problem jeg hadde som jeg kommer til under) og at alt er tilstrekkelig universelt utformet (som ikke var et stort tema mtp hvordan utforming av oppgaven). Jeg har bare brukt Systemfonter og SF Symbols for at alt skal være veldig 'Apple' og overholde HIG, oppgaven nevner nounproject som alternativ men sier aldri spesifikt at dette må brukes, så jeg har tolket det som at vi egentlig kan velge selv og da er SF Symbols alltid noe som vil passe godt inn i økosystemet.

## Bugs
Desverre har jeg fått en designbug på Containeren i Kartsiden som gjør at både kartet og labelene i containerviewet renderes feil på noen enheter, enkelte er hele siden blank. Dette har jeg gjort flere forsøk på å korrigere, og jeg har brukt ulike autolayout setopp for å minimere, samt hørt på assistenten underveis. Jeg ser ingen måte at dette kan korrigeres via layouts alene, men det kan hende feilen ligger i hvordan containercontrolleren henger sammen med parenten. Jeg har i midlertid gjort det jeg kan for å få det til å funke, jeg anbefaler at denne testes med en iPhone 11 Pro Max Simulator for å sjekke funksjonalitet, alt skal rendres ganske greit på denne enheten.
Bilder vil renderes i ganske ulik størrelse på ulike enheter, men skal vises på alle. Jeg har ikke prioritert å legge dem opp i ulike størrelser basert på skjermen siden designet ikke skulle prioritieres.

## Referanser
Jeg har brukt oppslagsverk, forelesningsmateriale, Udemy og StackOverflow flittig underveis i prosjektet. I de situasjonene hvor jeg har basert koden min på andres verk er dette sitert med beskrivende kommentarer. Alle lenker til verk jeg har referert underveis følger også her.

https://www.udemy.com/course/ios-13-app-development-bootcamp/ - Angela Yu sitt Udemy kurs. Jeg har referert til i koden at mitt API og delegate-pattern er basert på denne kursserien
https://www.bobthedeveloper.io/blog/pass-data-with-nsnotification-in-swift - Oversikt over bruk av NotificationCenter
https://medium.com/@felicity.johnson.mail/core-data-vs-nskeyedarchiver-vs-user-defaults-e660d541bb6e - Gjennomgang av de ulike måtene å persistere data på - jeg valgte UserDefaults basert på dette og dvs. StackOverflow tråder som var enige om at UserDefaults var effektiv for mindre datasett

https://stackoverflow.com/a/41111362 - Implementasjon av GestureRecognizer med bruk av @objc funksjon
https://stackoverflow.com/a/25451592/14283546 - Bruk av LocationManager
https://stackoverflow.com/a/39185097 - Splicing av Strings
https://stackoverflow.com/a/50710991 - ErrorToast funksjonalitet i appen min.
