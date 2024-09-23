# 2048

## Contexte et objectifs
Cette application est une implémentation du jeu 2048 en Flutter, où les utilisateurs doivent combiner des tuiles portant les mêmes valeurs pour obtenir des tuiles de valeur plus élevée. Le but ultime est d'atteindre la tuile 2048 (ou plus encore !).

L'objectif principal était d'organiser et de structurer le code de manière à pouvoir gérer efficacement l'état du jeu, y compris le plateau, le score, et la gestion des mouvements. Le Provider a été utilisé pour gérer l'état de manière réactive et centralisée.

## Choix d'implémentation
### Utilisation de Provider
J'ai opté pour le package Provider pour plusieurs raisons :

Gestion d'état réactive : Le jeu nécessite une gestion en temps réel des mouvements, des scores, et de l'état du plateau. Avec Provider, chaque changement d'état (comme un déplacement ou une fusion des tuiles) entraîne une mise à jour immédiate de l'interface utilisateur grâce à la méthode notifyListeners(). Cela permet de maintenir une synchronisation fluide entre la logique du jeu et l'affichage.

Centralisation de l'état : Toute la logique du jeu (comme les mouvements, l'ajout de nouvelles tuiles, la fusion et le suivi du score) est gérée dans une seule classe, GameProvider. Cela favorise une séparation des préoccupations en isolant la logique du jeu du code d'interface utilisateur.

Persistance de l'état : Grâce à l'intégration de SharedPreferences, nous avons pu implémenter une persistance de l'état pour que l'utilisateur puisse reprendre une partie en cours. Provider facilite cette gestion centralisée des données en rendant simple l'accès aux méthodes de chargement et de sauvegarde de l'état.

### Séparation des composants
Le code est organisé de manière modulaire pour faciliter la lisibilité et la maintenance :

GameProvider : Contient la logique du jeu (gestion du score, déplacements, fusion des tuiles, etc.).
GameScreen : Interface utilisateur principale qui affiche le plateau de jeu et les scores. Utilise des GestureDetector pour capturer les mouvements de l'utilisateur.
GameHeader : Affichage du score et du score maximum, alimenté par le Provider.
Cette séparation améliore la lisibilité du code et permet des mises à jour plus simples.

### Détection des mouvements
L'implémentation utilise les événements onPanStart, onPanUpdate et onPanEnd pour détecter les gestes de l'utilisateur (swipes) et déclencher les mouvements correspondants dans le jeu. Cela permet une interaction fluide et intuitive.

### Réalisation d'une maquette
Après avoir développé une boucle de jeu fonctionelle mais peu ergonomique et esthétique, j'ai réalisé une maquette sur figma. J'ai ensuite modifier le design de mon appli en suivant la maquette afin d'améliorer l'expérience utilisateur. Voici le lien menant à la maquette: https://www.figma.com/proto/XvhOdPMqqqbQbPnI5oqxDp/2048?node-id=1-3&t=z9o7ZI0wMuA88qvG-1 

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
