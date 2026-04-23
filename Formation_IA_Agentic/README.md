# 🤖 Formation Intelligence Artificielle & Agentic AI Appliquée au Développement

Bienvenue dans le dépôt de la formation **IA & Agentic AI**. Ce dépôt contient les supports théoriques et surtout les **ateliers pratiques** permettant aux développeurs d'intégrer des LLM et des agents autonomes dans leur workflow quotidien (Copilot, Cursor, Claude Code).

---

## 🗺️ Organisation du Dépôt

```
Formation_IA_Agentic/
├── README.md                                  ← Ce fichier d'accueil
├── 📚 supports_cours/
│   ├── Formation_IA_Agentique_Complet.pptx    ← Slides de présentation
│   ├── Formation_IA_Agentique_Developpeurs.docx ← Support exhaustif
│   ├── Plan_Formation_IA_Agentique.pdf        ← Syllabus PDF
│   └── IA_Agentique_Analogies.docx            ← Fiches concepts & analogies
└── 🛠️ ateliers/                                ← Exercices pratiques (Hands-on)
    ├── 01-tokens-et-contexte/                 ← Atelier 1 : Découverte Tokens & Contexte
    ├── 02-prompt-engineering/                 ← Atelier 2 : Architecture d'un Prompt
    ├── 03-tdd-ia-assist/                      ← Atelier 3 : Génération Tests & Code
    ├── 04-refactoring-legacy/                 ← Atelier 4 : Reverse Engineering & Refacto
    └── 05-plan-action-ia/                     ← Atelier 5 : Plan d'adoption personnel
```

---

## 🎯 Liste des Ateliers Pratiques (Hub)

L'IA ne s'apprend pas qu'en théorie, elle se pratique. **Cliquez sur un atelier pour accéder à son énoncé complet.**

| Module | Atelier | Objectif Clé |
|--------|---------|--------------|
| **Mod. 01** | [👉 Atelier 1 : Tokens & Contexte](./ateliers/01-tokens-et-contexte/README.md) | Comprendre comment un LLM lit le code (Tokenization) |
| **Mod. 03** | [👉 Atelier 2 : Prompt Engineering](./ateliers/02-prompt-engineering/README.md) | Écrire des prompts en 5 composantes pour générer du code parfait |
| **Mod. 04** | [👉 Atelier 3 : TDD Assisté par IA](./ateliers/03-tdd-ia-assist/README.md) | Générer les tests Jest/Pytest AVANT le code pour `calculateDiscount` |
| **Mod. 05** | [👉 Atelier 4 : Refactoring avec Claude](./ateliers/04-refactoring-legacy/README.md) | Laisser un agent autonome expliquer et nettoyer du code legacy |
| **Mod. 06** | [👉 Atelier 5 : Plan d'Action](./ateliers/05-plan-action-ia/README.md) | Formaliser votre stratégie personnelle d'adoption de l'IA (3 horizons) |

---

## 💡 Principes Fondamentaux de l'IA au quotidien (Rappel)

1. **Verify, Don't Trust Blindly** : L'IA hallucine. Ne poussez jamais en prod un code généré que vous ne comprenez pas entièrement.
2. **Le Contexte est Roi** : L'IA ne connaît que ce que vous lui donnez dans son "Context Window". Fournissez-lui les types, les interfaces et les conventions de votre projet.
3. **Pensez "Agentique" (Étape par Étape)** : Au lieu de demander "Fais cette feature MVP", demandez "1. Planifie l'architecture. 2. Écris les tests. 3. Implémente le backend. 4. Fais le frontend."

Bonne formation !
