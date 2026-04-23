# Atelier 3 : Création d'un mini Design System

**Durée estimée :** 25 minutes  
**Type :** UI Avancée dans Figma

## 🎯 Objectif
Assurer la cohérence d'un projet entier grâce à l'utilisation d'une **Palette de couleurs centralisée** (Tokens) et de **Composants / Variantes**.

---

## 🛠️ Instructions

### Étape 1 : Typographie et Couleurs
La force d'un Design System est de ne pas choisir ses couleurs au hasard.
1. Créez 3 petits carrés. Un pour la couleur *Primary* (Action principale), un *Secondary*, et un *Danger/Warning*.
2. Sélectionnez le carré *Primary*. Dans le panneau Fill, au lieu de juste une couleur, cliquez sur l'icône avec 4 points (`Style`) puis sur l'icône de paramètre (`+`) "Create style" ou "Variables".
3. Nommez-le "Color/Primary". Faites pareil pour les autres.
4. Créez un titre H1 et un texte "Body". Sauvegardez-les dans les "Text Styles".
*Désormais, si vous modifiez "Color/Primary", tous les éléments qui l'utilisent se mettront à jour !*

### Étape 2 : Créer le Composant Maître <Button>
1. Dessinez une boîte de texte "Click me". Utilisez votre typographie "Body".
2. Appuyez sur `Shift + A` pour créer un Auto-Layout. 
3. Donnez un fond "Color/Primary" à la frame de l'Auto Layout.
4. Ajoutez des Paddings de 16px à gauche/droite, 12px haut/bas, et un Corner Radius de 8px.
5. Sélectionnez le tout, et cliquez sur l'icône "Rombes" ❖ en haut au centre : **Create Component**.

### Étape 3 : Variantes de votre composant
Un bouton peut être normal, survolé, grand, petit, ou avoir le rôle d'alerte (Danger).
1. Sélectionnez votre Composant Maître. Dans le panneau de droite, cliquez sur le petit "+" à côté de "Properties", puis **Variant**.
2. Figma crée un cadre de variations pointillé violet.
3. Dupliquez votre bouton à l'intérieur de la boîte violette. Vous avez maintenant une Variante 2.
4. Dans les Options de la Variante, donnez la Property `State` : valeur `Hover`.
5. Modifiez l'apparence de cette variante "Hover" (par exemple, utilisez la couleur Secondary ou assombrissez le Primary).
6. Ajoutez une 3ème Variante pour l'état `Disabled` (grise).

### Étape 4 : L'usage (Le Test)
1. Instanciez votre composant maître ailleurs dans un autre écran.
2. Dans le panneau de droite de cette occurrence, jouez avec le dropdown "State" pour passer sans heurts d'un bouton Normal à Hover ou Disabled.

---

## 📝 Livrable attendu
- Un canevas documenté séparé servant de référence dans Figma.
- Un Master Component `<Button>` très souple avec un Auto Layout parfait et au moins 3 variantes distinctes activables via le panneau des propriétés.
