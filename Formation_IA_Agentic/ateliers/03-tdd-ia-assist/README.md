# Atelier 3 : Test-Driven Development (TDD) Assisté par IA

**Mode :** Live Coding & Pair Programming avec l'IA

## 🎯 Objectif
Renverser la façon classique de développer : Au lieu de demander le code puis les tests (ce que l'IA fait souvent mal car elle fait des tests "de complaisance"), on demande à l'IA de générer les tests d'après un cahier des charges, puis d'écrire le code pour faire passer les tests.

---

## 🛠️ Instructions

### Étape 1 : Demander la génération des Tests
Ouvrez l'IA de votre choix (Cursor/Copilot Chat/Claude) avec le prompt suivant.
*(Imaginez que nous développons une plateforme e-commerce)*.

```text
Rédige les tests unitaires (en utilisant Jest) pour une fonction `calculateDiscount(price, discountCode, userType)`.

Règles de gestion :
- price doit être > 0.
- `userType`="PREMIUM" donne -10% d'office.
- `discountCode`="SUMMER" donne -20%.
- Les réductions se cumulent mais le prix final ne peut pas baisser de plus de 50% du prix d'origine.
- Si le code est invalide, on applique la réduction liée au status PREMIUM s'il y a lieu, ou pas de réduction.

Génère UNIQUEMENT le bloc des tests (describe/it). Essaie de trouver les cas pièges (Edge Cases).
Ne génère PAS l'implémentation de la fonction pour l'instant.
```

1. Analysez les cas de tests générés par l'IA. Y a-t-il des cas limites pertinents (ex: price = 0 ou négatif) ?

### Étape 2 : Validation avec l'Agent
2. Demandez-lui : *"Voici les tests générés. Peux-tu maintenant m'écrire l'implémentation TypeScript stricte qui fera passer 100% de ces tests du premier coup ?"*

### Étape 3 : L'Itération
3. Lisez le code généré. Que se passe-t-il s'il y a plus tard un `discountCode="WINTER"` ? L'IA a très sûrement fait de nombreux `if/else` imbriqués.
4. Demandez-lui un refactoring propre : *"Le code passe les tests mais utilise trop de `if/else`. Refactore l'implémentation pour utiliser un pattern 'Strategy' ou un dictionnaire de codes de réduction, tout en gardant les tests au Vert."*

---

## 📝 À retenir
Le TDD assisté par IA s'assure que *vous* vérifiez les règles métiers avant d'accepter le code fonctionnel. C'est la méthode la plus sûre pour créer du code robuste.
