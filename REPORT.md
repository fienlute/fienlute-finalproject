# geleerd
zelf problemen oplossen 
firebase gebruiken 

# problemen
groepen in firebase 
login
volgorde tableview
Segmentation fault 11


## Description

De app 'GOals' is een app waarin de gebruiker op speelse wijze wordt gestimuleerd om zijn/haar doelen/dromen te bereiken. De gebruiker van deze app kan een account aanmaken en zelf een nieuwe groep aanmaken of aan een bestaande groep deelnemen. Binnen deze groep kan elke gebruiker doelen toevoegen, waar punten aan gekoppeld zijn. Wanneer je als gebruiker een doel hebt bereikt kun je het afvinken en worden de punten van het doel toegevoegd aan je puntensaldo. Zo zal er een klassement ontstaan, gesorteerd op wie er de meeste punten heeft. Op deze manier zullen gebruikers dromen en doelen niet langer uitstellen omdat ze 'geen tijd hebben'; ze zullen er tijd voor maken. 

screenshot


## Design

overview 

### LoginViewController
Op de LoginViewController kan de gebruiker (user) een account aanmaken (button: signup) of inloggen als ze al een account hebben (button: login). Als er een account wordt aangemaakt moet de user naast een emailadres en een wachtwoord, ook een groep opgeven of aanmaken waaraan hij/zij wil deelnemen. De users worden opgeslagen in de realtime database Firebase. Om naast het emailadres aanvullende informatie toe te kunnen voegen aan het userssaccount heb ik een struct gemaakt voor users (User.swift). Hierin wordt de volgende informatie van de user opgeslagen: 

    * een unieke user id (uid)
    * het emailadres
    * de groep waarin de user zit 
    * het aantal punten dat de user heeft behaald. 
    
### GoalsViewController
Na het aanmaken van een account wordt de user automatisch ingelogd. Als de gebruiker succesvol is ingelogd dan komt hij/zij op de GoalsViewController terecht. Op deze viewcontroller zijn alle doelen van de groep van de huidige gebruiker te zien. Er wordt over alle doelen in Firebase geloopt en gekeken of de groep van het doel gelijk is aan de groep van de huidige gebruiker. Als dit het geval is dan wordt het doel getoond in de tableview van deze viewcontroller. Op deze pagina kan de gebruiker niet alleen alle toegevoegde doelen van de gebruikers van de groep zien, maar ook zelf doelen toevoegen. Wanneer de user een doel toe wil voegen moet hij/zij op het plus teken drukken in de hoek van de viewcontroller. Hierna verschijnt er een alert waarin hij/zij de naam van het doel en het aantal punten dat het waard is moet opgeven. Als een doel opgeslagen wordt (button: Save), dan wordt het doel opgeslagen in Firebase. Om alle informatie van zo'n doel op te kunnen slaan heb ik een struct voor het doel aangemaakt (Goal.swift). Hierin wordt de volgende informatie van het doel opgeslagen: 

    * de naam van het doel
    * door welke gebruiker het doel is toegevoegd
    * de groep waarin deze gebruiker zit 
    * of het doel is behaald door een van de gebruikers
    * door welke gebruiker het doel behaald is
    * de punten die het doel waard is 

Wanneer een gebruiker een doel heeft behaald kan hij/zij op de cell van het doel klikken, waarna het completedBy child van het doel wordt bijgewerkt naar het emailadres van de huidige gebruiker. Wanneer een doel is behaald wordt deze verwijderd uit de GoalsViewController tableview. Hierdoor krijgt alleen de gebruiker die een doel als eerste behaald de punten opgeteld bij zijn/haar puntensaldo. 

Als de gebruiker terug wil komen naar de GoalsViewController moet hij/zij op de meest linker tabbarbutton drukken. 

### RankingViewController
Op de RankingViewController (middelste tabbarbutton) zijn alle gebruikers te zien die in dezelfde groep zitten als waar de huidige gebruiker in zit. In de tableview zijn alle gebruikers van de groep te zien met het aantal punten dat ze hebben. Er wordt over alle opgeslagen gebruikers in Firebase geloopt. De gebruikers die dezelfde groep hebben als de huidige gebruiker worden in een array gestopt. Deze array met de gefilterde gebruikers wordt geprint in de tableview. Uit de user objecten in deze array worden de emailadressen en het puntensaldo van de gebruikers gehaald, die worden geprint in de cellen van de tableview.

### DetailViewController
Op de DetailViewController (meest rechter tabbarbutton) zijn het emailaders, het puntensaldo en alle doelen die de gebruiker behaald heeft te zien. Om de behaalde doelen van de huidige gebruiker te laten zien wordt er over alle opgeslagen doelen in Firebase geloopt en gekeken of het completedBy child van het Goal object gelijk is aan het emailadres van de huidige gebruiker. Als dit het geval is worden deze toegevoegd aan een array, die vervolgens geprint wordt in de tableview op deze viewcontroller. 

## Challenges / changes 
Ik heb in het begin veel moeite gehad met Firebase. Vooral het ophalen van opgeslagen informatie vond ik lastig. Hier ben 

## Defend descisions / perfect world
Door de moeite die ik had met Firebase ben ik veel tijd verloren. Ik heb daarom niet meer kunnen behalen dan mijn minimum valuable product. Ook heb ik ervoor gekozen om de gebruikers niet o



    
