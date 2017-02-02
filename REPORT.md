# GOals 
### Fien Lute
### Programmeer Project 
### 10752862


## Description

De app 'GOals' is een app waarin de gebruiker op speelse wijze wordt gestimuleerd om zijn/haar doelen/dromen te bereiken. De gebruiker van deze app kan een account aanmaken en zelf een nieuwe groep aanmaken of aan een bestaande groep deelnemen. Binnen deze groep kan elke gebruiker doelen toevoegen, waar punten aan gekoppeld zijn. Wanneer je als gebruiker een doel hebt bereikt kun je het afvinken en worden de punten van het doel toegevoegd aan je puntensaldo. Zo zal er een klassement ontstaan, gesorteerd op wie er de meeste punten heeft. Op deze manier zullen gebruikers dromen en doelen niet langer uitstellen omdat ze 'geen tijd hebben'; ze zullen er tijd voor maken. 



## Design

### LoginViewController
Op de LoginViewController kan de gebruiker (user) een account aanmaken (button: signup) of inloggen als ze al een account hebben (button: login). Als er een account wordt aangemaakt moet de user naast een emailadres en een wachtwoord, ook een groep opgeven of aanmaken waaraan hij/zij wil deelnemen. De users worden opgeslagen in de realtime database Firebase. Om naast het emailadres aanvullende informatie toe te kunnen voegen aan het userssaccount heb ik een struct gemaakt voor users (User.swift). Hierin wordt de volgende informatie van de user opgeslagen: 

| User   | Values | 
| -------|:------:| 
| uid    | String |   
| email  | String |   
| group  | String |   
| points | Int    |   

### GoalsViewController
Na het aanmaken van een account wordt de user automatisch ingelogd. Als de gebruiker succesvol is ingelogd dan komt hij/zij op de GoalsViewController terecht. Op deze viewcontroller zijn alle doelen van de groep van de huidige gebruiker te zien. Er wordt over alle doelen in Firebase geloopt en gekeken of de groep die is opgeslagen bij het doel gelijk is aan de groep van de huidige gebruiker. Als dit het geval is dan wordt het doel getoond in de tableview van deze viewcontroller. Op deze pagina kan de gebruiker niet alleen alle toegevoegde doelen van de groep zien, maar ook zelf doelen toevoegen. Wanneer de user een doel toe wil voegen moet hij/zij op de + button drukken in de hoek van de viewcontroller. Hierna verschijnt er een alert waarin hij/zij de naam van het doel en het aantal punten dat het waard is moet opgeven. Als een doel opgeslagen wordt (button: Save), dan wordt het doel opgeslagen in Firebase. Om alle informatie van zo'n doel op te kunnen slaan heb ik een struct voor het doel aangemaakt (Goal.swift). Hierin wordt de volgende informatie van het doel opgeslagen: 

| Goal       | Values | 
| -------    |:------:| 
| name       | String |     
| addedByUser| String |       
| completed  | Bool   |       
| points     | Int    |      
| group      | String |      
| completedBy| String | 

Wanneer een gebruiker een doel heeft behaald kan hij/zij op de cell van het doel klikken, waarna de completedBy parameter van het doel wordt bijgewerkt naar het emailadres van de huidige gebruiker. Wanneer een doel is behaald wordt deze verwijderd uit de GoalsViewController tableview. Hierdoor kan alleen de gebruiker die een doel als eerste heeft behaald de punten opgeteld krijgen bij zijn/haar puntensaldo. 

Als de gebruiker later terug wil komen naar de GoalsViewController moet hij/zij op de meest linker tabbarbutton drukken. 

### RankingViewController
Op de RankingViewController (middelste tabbarbutton) zijn alle gebruikers te zien die in dezelfde groep zitten als waar de huidige gebruiker in zit. In de tableview zijn alle gebruikers van de groep te zien met het aantal punten dat ze hebben. Om dit in de tableview te tonen, wordt er over alle opgeslagen gebruikers in Firebase geloopt. De gebruikers die dezelfde groep hebben als de huidige gebruiker worden in een array gestopt. Deze array met de gefilterde gebruikers wordt geprint in de tableview. Uit de user objecten in deze array worden de emailadressen en het puntensaldo van de gebruikers gehaald. Deze informatie wordt getoond in de cellen van de tableview.

### DetailViewController
Op de DetailViewController (meest rechter tabbarbutton) zijn het emailaders, het puntensaldo en alle doelen die de gebruiker behaald heeft te zien. Om de behaalde doelen van de huidige gebruiker te laten zien wordt er over alle opgeslagen doelen in Firebase geloopt en gekeken of het completedBy child van het Goal object gelijk is aan het emailadres van de huidige gebruiker. Als dit het geval is wordt het doel  toegevoegd aan een array, die vervolgens geprint wordt in de tableview op deze viewcontroller. 

### methods 
retrieveUserDataFirebase() -> haalt de gewenste informatie van de gebruiker uit firebase.  
retrieveGoalDataFirebase() -> haalt de gewenste informatie van het goal uit firebase.


## Challenges / changes 
In het begin van het project heb ik veel moeite gehad met Firebase. Vooral het ophalen van opgeslagen informatie vond ik lastig. Doordat ik met meerdere gebruikers en groepen werk, werd het gebruik van Firebase een stuk complexer dan dat ik tot nu toe gewend was. Door de moeite die ik had met Firebase ben ik veel tijd verloren. Ik heb daarom niet meer kunnen behalen dan mijn minimum viable product. Ook heb ik de beslissing gemaakt om mijn oorspronkelijke idee van het opslaan in groepen om te gooien. In plaats van users in een groep op te slaan, heb ik ervoor gekozen om de groep van de user in de user struct op te slaan. Een ander probleem waar ik tegenaan liep was dat het wel lukte om te registreren, maar niet meer om in te loggen. Ik dacht dat dit eraan lag dat ik de data van de ingelogde gebruiker niet goed ophaalde vanuit Firebase. Dit bleek echter aan een foutieve segue te liggen. Daarnaast zit er een segmentation fault in mijn app die ik er niet uit heb kunnen krijgen: Segmentation fault 11. De app runt gelukkig meestal wel. Als hij niet runt, dan moet ik hem nogmaals runnen en dan doet hij het weer.
Ik heb deze maand geleerd om om te gaan met Firebase: het opslaan en ophalen van informatie en deze informatie verwerken. Ook ben ik het gebruik van stucts beter gaan begrijpen en de relatie tussen de verschillende viewcontrollers. We hadden per week niet veel hulp, waardoor ik heb geleerd om zelf veel problemen op te lossen en om te gaan met errors. Door standup meetings ben ik beter geworden in het uitleggen van de constructies en het design van mijn app aan medestudenten, waardoor zij mij konden helpen. Hierdoor werd ik ook beter in het lezen en begrijpen van andermans code, waardoor ik mijn groepsleden ook kon helpen. 


## Defend descisions / perfect world
Ik heb bij het maken van deze app gekozen voor kwaliteit over kwantiteit. Ik heb niet meer functionaliteit geimplementeerd dan mijn minimale product. Ik denk dat dit een goede keuze is geweest, omdat betere code voor mij belangrijker is dan meer functionaliteit. Daarnaast denk ik dat het voor mij slim is geweest om niet meer te doen met Firebase dan nodig was voor mijn minimale product. Omdat ik al zo veel moeite had met Firebase denk ik dat ik daar te lang over had gedaan. Als ik de app opnieuw zou maken zou ik meer kunnen doen met Firebase omdat ik het een stuk beter begrijp. Dit was nu niet haalbaar omdat ik dan mijn structs en constructie van de code helemaal zou moeten opgooien. 
Ik ben super blij dat ik mijn minale product volledig heb kunnen behalen. In een perfecte wereld waarin ik alle tijd zou hebben zou mijn app meer functionaliteit hebben. Ik zou er bijvoorbeeld voor zorgen dat 60% van de gebruikers in de groep een doel moet goed keuren voordat deze wordt toegevoegd aan de doelen pagina. Ook zou ik de optie geven om een foto toe te voegen wanneer een gebruiker een doel bereikt. De behaalde doelen worden gepresenteerd op een live feed, waar alle gebruikers kunnen zien wat de andere gebruikers uit de groep recent hebben behaald. Daarnaast zou ik een groeps object maken bestaande uit meerdere user objecten. Ik denk dat dit bij het uitbreiden van deze app een betere constructie zou zijn, omdat het overzichtelijker zou zijn in Firebase. Ik heb ervoor gekozen om mijn app alleen in portrait orientation te presenteren. Dit is voor mijn app een goede keuze omdat ik gebruik maak van veel table views. Ik vind het zelf onhandig om een tableview te gebruiken in landscape orientation. 

