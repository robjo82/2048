# Projet 2048 Flutter

Ce projet est une implémentation du jeu 2048 en Flutter, conçue pour offrir une expérience fluide et réactive. Il s'appuie sur des technologies modernes pour la gestion d'état, la persistance des données et la détection des interactions utilisateur.

---

## Architecture et Structure

- **GameProvider**
    - **Responsabilités :**
        - Gestion de l'état du jeu (grille, score, high score, état précédent pour l'annulation).
        - Logique de déplacement et fusion des tuiles via la méthode `_merge()`.
        - Sauvegarde et chargement de l'état du jeu à l'aide de `SharedPreferences`.
        - Vérification de la fin de partie grâce à `_checkGameOver()` et mise à jour de l'indicateur `_isGameOver`.
    - **Avantages :**
        - Séparation claire entre la logique métier et l'interface utilisateur.
        - Utilisation de `ChangeNotifier` pour notifier automatiquement l'UI lors des changements d'état.

- **GameScreen**
    - **Responsabilités :**
        - Affichage de la grille de jeu et du header (scores et boutons).
        - Gestion des gestes (balayage) via `GestureDetector` pour déclencher les mouvements.
        - Superposition d'un overlay (`GameOverOverlay`) lorsque la partie est perdue.
    - **Avantages :**
        - Interface réactive et intuitive.
        - Séparation de la logique de détection des gestes et de l'affichage de l'overlay.

- **GameHeader**
    - **Responsabilités :**
        - Affichage des scores actuels et du high score.
        - Boutons pour réinitialiser le jeu et annuler le dernier mouvement.
    - **Avantages :**
        - Interface claire et ergonomique pour l'utilisateur.

- **GameOverOverlay**
    - **Responsabilités :**
        - Affichage d'un écran de fin de jeu lorsque le jeu est perdu.
        - Proposition d'un bouton permettant de redémarrer le jeu.
    - **Avantages :**
        - Feedback immédiat à l'utilisateur en cas de blocage, avec une option de réinitialisation facile.
