## GOals 
Fien Lute  
Programmeer project   
Copyright (c) 2017 fienlute


### Global summary 
De app 'GOals' is een app waarin de gebruiker op speelse wijze wordt gestimuleerd om zijn/haar doelen/dromen te bereiken. De gebruikers van de app kunnen binnen een groep doelen toevoegen. Ze kunnen deze doelen afvinken/bereiken, waarna het puntenaantal van het doel wordt opgeteld bij het puntensaldo van de gebruiker. Zo onstaat er een klassement tussen de gebruikers, waarin de gebruiker met de meeste punten bovenaan staat. 

### Description
Het eerste scherm is de LoginViewController. Hier kan de gebruiker inloggen/registreren. De users (User.swift) zijn/worden opgeslagen in de realtime database Firebase. Na het inloggen/registreren wordt de user doorverwezen naar de GoalsViewController. Hier zijn alle doelen te zien die toegevoegd zijn in de groep van de huidige gebruiker. De gebruiker kan op deze pagina nieuwe doelen (Goal.swift) toevoegen door op het + teken te drukken. De doelen worden opgeslagen in Firebase. Ook kan de gebruiker uitloggen op deze pagina. In de tab-bar kan de gebruiker navigeren naar de RankingViewController en de DetailViewController. Op de RankingViewController zijn alle gebruikers van de groep van de huidige gebruiker weergegeven met hun puntensaldo. De gebruikers zijn geordend op hoogte van puntensaldo. Op de DetailViewController zijn het puntensaldo en de behaalde doelen van de huidige gebruiker te zien. 

### Screenshots

![alt tag] (https://github.com/fienlute/programmeerproject/blob/master/doc/screenshots%20goals.png)
### bettercodehub
[![BCH compliance](https://bettercodehub.com/edge/badge/fienlute/programmeerproject)](https://bettercodehub.com)

### Sources 

https://firebase.google.com/docs/database/ios/read-and-write  
(retrieving data from firebase)

https://www.raywenderlich.com/139322/firebase-tutorial-getting-started-2   
    (used in LoginViewController en User.swift)  

https://code.tutsplus.com/tutorials/ios-from-scratch-with-swift-exploring-tab-bar-controller--cms-25470       (tab-bar tutorial)  

https://grokswift.com/transparent-table-view/   
    (hide empty cells in tableview)  





