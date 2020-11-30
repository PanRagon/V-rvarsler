
Kandidatnummer 10042



## Utforming
Jeg har underveis i prosjektet prøvd å vise fram gode designprinsipper underveis, og spesielt MVC-modellen. Jeg har basert meg på forelesningsmateriale og kurs underveis, og jeg har prøvd å få til abstraksjon der det gir mening, slik som i API-kallene og i LocationData-modellen (jeg kommer tilbake til hvorfor denne ikke er helt ideel, men veldig tilstrekkelig for oppgaven). Oppgavene baserer seg på bruk av lokasjonsdata fra brukeren, jeg har tatt høyde for at disse dataene kan skrus av av brukeren, og i de tilfellene er værmeldinger basert på HK (men pin-funksjonalitet på kart fungerer fortsatt)

## Oppgaver
Jeg har fullført alle oppgavene med alle krav fram til oppgave 4.

## Værmelding
Denne siden er lagd med TableView slik oppgaven beskriver og fetcher sine data fra WeatherAPI. Lokasjonen som brukes er basert på LocationData som muteres av KartViewet når den er i bruk, og vil hellers hente data for HK. Det er litt ulikt design på cellene i referansebildet fra oppgaven, men jeg har i hvert fall tatt høyde for at den nederste labelen på venstre side vil være på linje med den første til høyre, og at den nederste cellen på høyre siden vil være blank der ingen precipitation informasjon finnes. 

## Kart
Kartet bruker MapKit view og implementerer en ContainerView for viewet med værinformasjon for brukeren. Pin-funksjonen vil fungere selv om brukeren har skrudd av deling av posisjonsdata. Jeg har tolket oppgave 3 som at viewet under kartet kan ha sin egen kontroller, og har derfor brukt en containerview med egen ViewController koblet til MapViewController. En annen tolkning av oppgaven kan være å kun lage et eget view uten view controller, koblet til MapViewControlleren med en IBOutlet, som implementerer WeatherAPIDelegate og fetcher data. Dette blir i mine øyne litt problematisk fra et softwaredesignutgangspunkt siden du da har en View som fetcher og manipulerer data, ikke en Controller, som jeg tolker som et brudd på MVC-modellen.
Kommunikasjon mellom Map og Container skjer gjennom en NotificationCenter, som gjør at data kan sendes og mottas frivillig av de klassene som implementerer en observer eller poster til den. En annen måte å kommunisere på er segues som brukes gjerne i parent/child-konteksten, jeg fant imidlertidig ingen løsning som var like uproblematisk som NotificationCenter når det gjaldt å ha en stream med info gående hele tiden, de fleste implementasjoner jeg så brukte den mer for en gangs overføringer. 

## Hjem
Hjemsiden har kun 3 elementer og persisterer data med UserDefaults. Forskjellen mellom UserDefaults og CoreData er at UserDefaults er en ustrukurert dictionary, mens CoreData gir tilgang på mer relasjonell lagring. Et dictionary var mer enn nok i konteksten jeg brukte det, jeg ønsker kun tilgang på litt dato og et symbol. Hjem tar i bruk samme WeatherAPI som Værmeldingen og Kart-siden, og implementerer LocationManager på samme måte som kartsiden. Merk at jeg har forstått det som viktig at de må ha vær sin og ikke bruke samme lokasjonsdata, da værmeldingen skal spesifikt vise HK fram til brukeren har tykker på kartet - selv om jeg queryer denne informasjonen allerede i hjem.

## Modeller
Jeg har prøvd å bruke meningsfulle modeller og datastrukturer for innholdet som skal vises

## Designbugs
Desverre har jeg fått en designbug på Containeren i Kartsiden som gjør at både kartet og labelene i containerviewet renderes feil på noen enheter, enkelte er hele siden blank. Dette har jeg gjort flere forsøk på å korrigere, og jeg har brukt ulike autolayout setopp for å minimere, samt hørt på assistenten underveis. Jeg ser ingen måte at dette kan korrigeres via layouts alene, men det kan hende feilen ligger i hvordan containercontrolleren henger sammen med parenten. Jeg har i midlertid gjort det jeg kan for å få det til å funke, jeg anbefaler at denne testes med en iPhone 11 Pro Max Simulator for å sjekke funksjonalitet, alt skal rendres ganske greit på denne enheten.

## Referanser
Jeg har brukt oppslagsverk, forelesningsmateriale, Udemy og StackOverflow flittig underveis i prosjektet. I de situasjonene hvor jeg har basert koden min på andres verk er dette sitert med beskrivende kommentarer. Alle lenker til verk jeg har referert underveis følger også her.

https://www.udemy.com/course/ios-13-app-development-bootcamp/ - Angela Yu sitt Udemy kurs. Jeg har referert til i koden at mitt API og delegate-pattern er basert på denne kursserien
https://www.bobthedeveloper.io/blog/pass-data-with-nsnotification-in-swift - Oversikt over bruk av NotificationCenter
https://medium.com/@felicity.johnson.mail/core-data-vs-nskeyedarchiver-vs-user-defaults-e660d541bb6e - Gjennomgang av de ulike måtene å persistere data på - jeg valgte UserDefaults basert på dette og dvs. StackOverflow tråder som var enige om at UserDefaults var effektiv for mindre datasett

https://stackoverflow.com/a/41111362 - Implementasjon av GestureRecognizer med bruk av @objc funksjon
https://stackoverflow.com/a/25451592/14283546 - Bruk av LocationManager
https://stackoverflow.com/a/39185097 - Splicing av Strings
https://stackoverflow.com/a/50710991 - ErrorToast funksjonalitet i appen min.
