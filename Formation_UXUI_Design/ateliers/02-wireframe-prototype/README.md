# Atelier 2 : Wireframe Mid-Fi & Prototypage Figma

**Durée estimée :** 25 minutes  
**Type :** Figma Hands-on

## 🎯 Objectif
Quitter l'étape du croquis et intégrer un wireframe Medium-Fidelity dans Figma en utilisant la fonctionnalité d'**Auto Layout**, et relier les écrans entre eux.

---

## 🛠️ Instructions

### Étape 1 : Le Wireframe du Dashboard
1. Ouvrez Figma (version Web ou Application Bureau).
2. Créez un nouveau **Design file**.
3. Ajoutez une Frame Desktop standard (ex: `Desktop - 1440 x 1024`).
4. À gauche, dessinez grossièrement (Mid-Fi = Boîtes grises et texte brut) :
   - Une Sidebar avec 4 liens au hasard (Dashboard, Clients, Invoices, Settings).
   - Un Header avec le titre de la page et un avatar.

### Étape 2 : Appliquer l'Auto Layout (IMPORTANT)
Au lieu de positionner des pixels manuellement, regroupons les éléments intelligemment.
1. Sélectionnez vos 4 liens de la sidebar.
2. Appuyez sur `Shift + A` pour créer un **Auto Layout**.
3. Explorez le panneau droit : changez la direction (verticale/horizontale), l'espace entre les éléments ("Spacing") et les "Paddings".
4. Observez que si vous ajoutez un 5e lien, l'espacement s'adapte automatiquement sans ruiner tout votre design. 

### Étape 3 : La Card Produit / KPI
1. En dehors de la frame principale, créez ce qu'on appelle "Une Card" contenant : Un gros chiffre (Le Chiffre d'Affaire), Un libellé (CA Mensuel), Une icône ou pastille de couleur.
2. Groupement `Auto Layout` sur l'ensemble.
3. Dupliquez plusieurs fois cette Card dans la zone "Main" de votre dashboard.

### Étape 4 : Prototypage Cliquable minimaliste
1. Dupliquez votre `Frame Desktop` complète. Prenez la 2e frame et changez le titre du Header (ex: "Mes Clients").
2. En haut à droite de Figma, passez de l'onglet **Design** à l'onglet **Prototype**.
3. Sélectionnez le bouton "Clients" dans votre Sidebar de l'écran n°1.
4. Tirez la flèche bleue ("Noodle") depuis ce bouton vers le Frame n°2. 
5. Cliquez sur l'icône Play (`▶`) en haut à droite pour tester l'interaction en direct.

---

## 📝 Livrable attendu
Un projet Figma possédant :
- Au moins deux écrans distincts réalisés avec d'importantes sections contrôlées par Auto Layout.
- Une transition prototypée fonctionnelle entre eux.
