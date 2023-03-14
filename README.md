# Noise And Order Processing

## Installation de l'IDE (environnement de développement)

https://www.youtube.com/watch?v=FlVFRzX6jtE

command + shift + B --> compiler et exécuter le code le

## Description

Dans un repère Euclidien, on a des boules qui sont alignées sur l’axe Z.

Boules :
même taille (la taille paraît différente à cause de la profondeur)

### But du programme sur processing:

Pilotage des axes X/Y:  
En cliquant et relâchant sur l’écran avec un doigt on peut enregistrer :  
le mouvement de la souris X - Y pendant 2 secondes  
au terme de ces deux secondes ce mouvement est répété en boucle avec une interpolation entre le dernier et le premier point de ce mouvement  
Ce mouvement est ensuite assigné à toutes les boules avec un décalage de N frames  
La boule 1 suit le mouvement enregistré parfaitement avec 1 _ N frame d’écart  
La boule 2 suit le mouvement enregistré avec 2 _ N frames d’écarts  
La boule 3 suit le mouvement enregistré avec 3 \* N frames d’écarts  
etc.

#### Explications sur les frames :

nombre d’image par seconde

#### Pilotage du zoom (sur l’axe Z)

En glissant avec deux doigts verticalement, on altère le zoom sur les boules  
On peut zoomer pendant le mouvement

#### Changement de la perspective (point du vue sur le plan)

Lors du mouvement des boules, on veut pouvoir changer le point de perspective sur le plan en cliquant
sauf qu’en cliquant on relance l'enregistrement

### But du programme final avec le matériel :   controler le mouvement des balles par l'intermediaire de signaux (Low Frequency Oscillation).
Les signaux serviront aussi bien à controler la vitesse de rotation des balles, qu'a les arreter selon des modalités de decalage en espace, en temps, en propagation, retropragation ...

#### Liste du matériel : 12 moteurs controlent des bras mecaniques auxquelles sont fixés de LED

#### Encodeur

donne la position du moteur
mapping entre la position de sur l’axe Y de la souris et la position du moteur sur 360 degrés - exemple
0 = O
100 = 45
200 = 90
300 = 135
400 = 180
…
800 = 360 = 0

Boules physique au bout d’un bras motorisé
le moteur permet au bras de bouger sur en cercle

Au lieu d’enregistrer le mouvement X, Y avec une souris, on va enregistrer le mouvement

