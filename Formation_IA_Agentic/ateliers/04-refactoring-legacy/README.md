# Atelier 4 : Refactoring de Legacy Code avec Claude

**Mode :** Manipulation autonome (Agentique)

## 🎯 Objectif
Utiliser un agent LLM intelligent pour :
1. Comprendre un bout de code ancien, mal nommé et non documenté.
2. Ajouter de la documentation explicative.
3. Implémenter des bonnes pratiques (Clean Code & Typage).

---

## 🛠️ Instructions

### Étape 1 : Le Code Plat de Nouilles (Spaghetti Legacy)
Copiez cette (terrible) fonction JavaScript :

```javascript
function clc(a,b,c) {
  let res = 0;
  if(a === 1) {
    for(let i=0; i<b.length; i++) {
        if(b[i].act && b[i].v > 0) res += b[i].v;
    }
    if (c) res = res * 1.2;
  } else if (a === 2) {
    res = b.filter(x => !x.act).length * 10;
  }
  return Math.round(res);
}
```

### Étape 2 : L'Explication (Reverse Engineering)
Créez un nouveau chat IA et tapez :
> "Explique-moi ce que fait cette fonction "clc", étape par étape, en déduisant son but métier probable d'après sa structure. Ne récris pas le code."

*L'IA va déduire qu'il s'agit potentiellement d'un outil de calcul (facture avec taxes, ou pénalités).*

### Étape 3 : Le Refactoring Étape par Étape
Au lieu de dire "Refactore cette merde", donnez un guidage :

> Excellent. Maintenant, réécris ce code en TypeScript moderne en respectant les principes Clean Code :
> 1. Renomme la fonction et tous les arguments avec des termes clairs.
> 2. Définis une Interface / Type pour le tableau "b".
> 3. Remplace la boucle 'for' par des méthodes de tableau modernes (reduce, filter, etc.).
> 4. Évite les "Else If" si on peut faire des "Early Returns".

Observez le résultat !

### Étape 4 (Bonus) : La PR Review
Demandez à l'IA d'agir dans un pipeline CI/CD :
> "Agis comme un Tech Lead très sévère sur GitLab. Rédige une Pull Request Review du premier code "clc(a,b,c)" que je t'ai fourni. Liste tous les "Code Smells" sous forme de bullet points."

---

## 📝 À retenir
Les LLMs sont souvent meilleurs pour la **compréhension** de code (reverse engineering) que pour la **création** ex-nihilo. Utilisez-les intensivement quand vous arrivez sur une nouvelle base de code ancienne !
