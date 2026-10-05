# Le Cabinet des Énigmes

Un jeu de casse-têtes pour faire travailler le cerveau, qui se joue directement dans le navigateur. Tout tient dans un seul fichier, `index.html`, sans installation.

## Jouer

- En ligne : ouvre le site GitHub Pages du dépôt.
- Sur ton ordinateur : double-clique sur `index.html`.

## Contenu

**Catalogues** : 21 jeux, chacun avec 25 niveaux de plus en plus difficiles (525 niveaux).

| Thème | Jeux |
|---|---|
| Logique | Suites logiques, Sudoku, Nonogramme, Code secret, Devinettes |
| Calcul | Calcul éclair, Le compte est bon |
| Mémoire | Mémoire de lampes, Paires, Objet disparu |
| Mots | Anagrammes, Mot mystère, Mots mêlés |
| Visuel | Tuyaux, Relier les couleurs, Pousse-caisses, Taquin, Éteins tout |
| Observation | Objets cachés, 7 différences, Trouve l’intrus |

**Aventure** : 25 tiroirs à ouvrir en 5 chapitres.

## Règles

- Chaque niveau rapporte jusqu’à 3 étoiles : une de moins si tu prends un indice, une de moins si tu fais trop d’erreurs.
- Un niveau se débloque quand le précédent est réussi. Un même niveau donne toujours la même grille.
- « Partie au hasard » crée une nouvelle grille à chaque fois.
- Avec un compte (e-mail + mot de passe), la progression est enregistrée en ligne et se retrouve sur n’importe quel ordinateur. Sans compte, elle reste dans le navigateur.

## Comptes joueurs (Supabase)

Une seule fois, dans le projet Supabase :
1. SQL Editor : exécuter `supabase-progression.sql` (table `progression`, chaque joueur ne voit que sa ligne).
2. Authentication > Email : désactiver « Confirm email », sinon les joueurs ne peuvent pas activer leur compte avec le service d’e-mail par défaut de Supabase.
