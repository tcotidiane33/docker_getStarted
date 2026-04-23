# Atelier 2 : L'Architecture d'un Prompt Optimisé (Code)

**Mode :** Pratique A/B Testing

## 🎯 Objectif
Écrire un prompt professionnel structuré en 5 composantes pour générer un résultat prévisible, testé et robuste dès le "Zero-Shot".

---

## 🛠️ Instructions

### Étape 1 : Le "Mauvais" Prompt (Prompt A)
Prenez ChatGPT, Claude ou Cursor, et tapez exactement ceci :
> "Fais une regex pour valider un numéro de téléphone."

Observez le résultat. L'IA a dû deviner le format (US ? Français ? E164 ?), le langage de programmation souhaité, et elle n'a probablement pas fourni de cas de tests exhaustifs.

### Étape 2 : Le Prompt Optimisé (Prompt B)
Nous allons utiliser la règle des **5 Composantes** : (1) Rôle, (2) Contexte, (3) Tâche, (4) Format, (5) Exemples / Contraintes.

Copiez le Prompt B structuré :
```text
Tu es un développeur Backend Senior expert en sécurité et qualité de code [RÔLE].
Je travaille sur un CRM français en TypeScript/Node.js où les commerciaux rentrent les numéros des clients manuellement [CONTEXTE].

Génère une fonction `isValidFrenchPhoneNumber(phone: string): boolean` qui retourne true si le numéro est valide. [TÂCHE]

Contraintes :
- Ne valide QUE les numéros français de métropole (commençant par 01 à 09, ou +33).
- Gère les espaces, les points et les tirets.
- Retourne uniquement le code TypeScript et une suite de tests unitaires (Jest). [EXEMPLES/CONTRAINTES/FORMAT]
```

Lancez ce prompt.

### Étape 3 : Comparaison
Comparez le code généré.
- Lequel des deux est prêt à être mis en production ?
- Lequel prend en compte le cas limite de l'ajout d'espaces (06 12 34...) ?

---

## 📝 À retenir
Pour toute tâche complexe, utilisez le format Rôle / Contexte / Tâche / Contraintes pour guider l'Agent. La qualité de la sortie ("Output") dépend à 100% de la qualité de l'entrée ("Input").
