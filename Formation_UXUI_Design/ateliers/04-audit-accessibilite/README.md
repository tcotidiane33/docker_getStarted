# Atelier 4 : Audit d'Accessibilité Numérique (WCAG / RGAA)

**Durée estimée :** 15 minutes  
**Type :** Analyse & Diagnostic

## 🎯 Objectif
Comprendre que l'interface doit être lisible pour plus de 10% de la population souffrant de déficits visuels ou de motricité. Pratiquer la conformité au niveau "AA" de la norme Web Content Accessibility Guidelines (WCAG 2.1).

---

## 🛠️ Instructions

### Étape 1 : Le Contraste (Contrast Ratio)
Un texte gris clair sur un fond blanc est illégal pour l'inclusion numérique.
1. Retournez dans votre Figma. Créez un texte "Conditions d'utilisation" avec la couleur `#808080` (gris) sur un fond blanc (`#FFFFFF`).
2. Ouvrez les plugins Figma (`Cmd/Ctrl + P` ou l'onglet `Plugins`). Cherchez "Contrast" ou "A11y - Color Contrast Checker" et lancez un plugin similaire gratuit.
3. Le plugin vous indiquera un ratio (par exemple : `4.0:1`).
*Question : Ce ratio est-il conforme au niveau Minimal (AA) (qui se situe à 4.5:1 pour le texte régulier) ?*

Corrigez la couleur pour passer au Vert côté plugin (généralement `#595959` ou un contraste de `4.5:1` ou plus).

### Étape 2 : Simulation de Daltonisme
Il existe de nombreuses formes de la perception des couleurs (Protanopie, Deutéranopie...). Si votre feu "rouge" d'alerte et votre feu "vert" de succès ont la même luminosité, la personne verra deux voyants gris identiques.

1. Sélectionnez une "alerte texte rouge sur fond clair" dans votre design.
2. Utilisez l'implémentation native de Figma (depuis le menu principal : View > ou Plugins cherchant Color Blindness simulator).
3. Observez l'alerte à travers les yeux de vos utilisateurs. L'erreur est-elle toujours claire si on enlève la couleur ? (Indice: C'est pour cette raison qu'on associe toujours une Icône ⚠️ à la couleur !).

### Étape 3 : Compréhension Zones tactiles (Fitt's Law)
Apple et Google sont drastiques sur ce point. Si un bouton fait un certain nombre de pixels d'espacement, l'utilisateur tapera à côté sur mobile. (Thumb Zone).
- Mesurez la hauteur des boutons que vous dessinez. *Un standard WCAG minimal exige 44x44px. Assurez-vous en !*

---

## 📝 Livrable attendu
Rédigez ou mettez en évidence : 
- L'audit "Avant / Après" avec la preuve que votre design respecte le seuil normé AA.
- La preuve que vous avez pensé au daltonisme en ajoutant des marqueurs "Signifiants" structurels (icônes) plutôt qu'uniquement de la teinte.
