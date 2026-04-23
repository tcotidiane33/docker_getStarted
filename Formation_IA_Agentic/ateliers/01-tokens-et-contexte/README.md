# Atelier 1 : Découverte Tokens & Contexte Limit

**Mode :** Exploration & Démonstration

## 🎯 Objectif
Comprendre qu'une IA ne lit pas des mots ou des caractères, mais des **Tokens**. Cette compréhension est cruciale pour maîtriser la "Context Window" et réduire les coûts d'appels API (ou éviter les coupures de contexte).

---

## 🛠️ Instructions

### Étape 1 : Le Tokenizer
1. Ouvrez le site officiel d'OpenAI Tokenizer : https://platform.openai.com/tokenizer 
2. Collez le code suivant dans l'interface :
   ```javascript
   function calculateDistance(x1, y1, x2, y2) {
       const dx = x2 - x1;
       const dy = y2 - y1;
       return Math.sqrt(dx * dx + dy * dy);
   }
   ```
3. Observez la coloration des tokens. 
*Questions :* 
- Combien de tokens ce code représente-t-il ? 
- Est-ce que les espaces (indentation) consomment des tokens ? Que se passerait-il si le code était minifié ?

### Étape 2 : L'impact sur le contexte
Les modèles comme Claude 3.5 Sonnet ou GPT-4o acceptent un très grand nombre de tokens (généralement 128k à 200k).
Sachant que 1 token ≈ 4 caractères en anglais :
- À peu près combien de lignes de code (disons 80 caractères par ligne) pouvez-vous injecter dans un prompt de 128 000 tokens ?
- *Réponse : ~60 000 lignes.* 

Est-il pertinent de "copier-coller" tout son projet dans le chat ? (Discutez des problèmes de "Lost in the middle" (Oubli par le LLM des instructions situées au milieu du texte)).

---

## 📝 À retenir
Fournissez à l'IA **uniquement les fichiers pertinents** (Les interfaces, un exemple d'implémentation, et le fichier à modifier) plutôt que l'entièreté d'un repo monolithique.
