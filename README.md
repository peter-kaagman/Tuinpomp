# Tuinpomp
## Inleiding
Tegenwoordig heb ik een hydrofoorpomp voor mijn tuin Aangezien ik een aantal druppelslangen heb (met weinig afname) leek mij dat handig, zodoende hoeft de pomp niet constant te draaien. Er zijn in princiepe 2 kringen: de druppelslangen, en de gazonsproeiers. Op dit moment sluit ik met de hand een kring aan en zet dan de pomp aan.
Dit wil ik uiteraard automatiseren. De pomp slaat vanzelf af als er voldoende druk is, maar de kringen wil ik aan kunnen zetten via een magneetklep.
## Functionele eisen
### Must have
- Er kunnen 2-4  kringen aangestuurd worden
- Wekelijks schema
- Instellen via een webinterface.
### Should have
- Kringen gelijktijdig als de pompcapaciteit dat toestaat.
- Handmatig aanzetten moet mogelijk zijn via hardware en software.
### Could have
- Rekening houden met neerslag(verwachting).
- Pomp droogloop beveiliging middels druksensor.
- Vochtsensoren voor aansturing.
## Platfom en tools
### Hardware
Als hardware platform wordt een Raspberry Pi gebruikt. Momenteel heb ik een 4B en een zero (v1) voor handen. De Pi stuurt een relais moduke aan die vervolgens 2 24V magneetkleppen aanstuurt. De 24V voeding zal ook gebruikt worden om de Pi te voeden. De Pi krijgt drukknoppen om een kring handmatig aan te kunnen zetten.
## Software
Software wordt geschreven in Perl in 2 modules: 
- een zogenaamde schema runner die checked of er een kring aan of uit moet
- een website (Dancer2 gebasseerd) waar de status uitgelezen kan worden, het schema aangepast of een kring handmatig aangezet kan worden.
Als database wordt SQLite3 gebruikt. 
