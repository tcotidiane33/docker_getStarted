# 🛡️ Formation Sécurité Applicative — Secure Coding & Best Practices

Bienvenue dans le dépôt de la formation **Sécurité Applicative**. Ce dépôt contient les supports de cours et surtout **les ateliers et cas pratiques** permettant aux développeurs Web/Mobiles/Backend d'appliquer immédiatement les principes de sécurité (OWASP).

---

## 🗺️ Organisation du Dépôt

```
Formation_Securite_Applicative/
├── README.md                                  ← Ce fichier d'accueil
├── 📚 supports_cours/
│   ├── Formation_Securite_Applicative.pptx    ← Slides de présentation
│   ├── Formation_Securite_Applicative.docx    ← Support complet
│   ├── Plan_Formation_Securite_Applicative.pdf← Syllabus
│   └── Securite_Applicative_Analogies.docx    ← Aide-mémoire & vulgarisation
└── 🛠️ ateliers/                                ← Exercices pratiques (Hands-on)
    ├── 01-owasp-juice-shop/                   ← TP 1 : Identifier le Top 10 OWASP
    ├── 02-audit-dependances/                  ← TP 2 : Audit & Hooks Git
    ├── 03-jwt-oauth-auth/                     ← TP 3 : Implémenter JWT + Refresh tokens
    ├── 04-sast-dast-tests/                    ← TP 4 : SonarQube & OWASP ZAP
    └── 05-xss-csrf-ssrf/                      ← TP 5 : Simulation XSS & CSRF
```

*(Note : Si vous ne voyez pas le dossier `supports_cours`, cela signifie que les documents PPTX/DOCX/PDF sont actuellement à la racine et peuvent y être déplacés pour plus de clarté).*

---

## 🎯 Liste des Ateliers Pratiques (Hub)

La formation met un accent très fort sur la pratique. Voici le tableau de bord des ateliers. **Cliquez sur un atelier pour accéder à ses instructions complètes.**

| Module | Atelier | Temps Estimé | Concepts Clés |
|--------|---------|--------------|---------------|
| **Mod. 02** | [👉 TP 1 : Audit OWASP Juice Shop](./ateliers/01-owasp-juice-shop/README.md) | 25 min | SQLi, XSS, A01 Broken Access Control |
| **Mod. 03** | [👉 TP 2 : Audit de Sécurité Projet](./ateliers/02-audit-dependances/README.md) | 20 min | `npm audit`, Secrets Git, Husky (Pre-commit) |
| **Mod. 04** | [👉 TP 3 : Implémentation JWT & Auth](./ateliers/03-jwt-oauth-auth/README.md) | 20 min | Access Token, Refresh Token, Blacklist, Rate Limit |
| **Mod. 06** | [👉 TP 4 : Scan SAST & DAST](./ateliers/04-sast-dast-tests/README.md) | 20 min | SonarQube (SAST), OWASP ZAP (DAST), CI/CD Gates |
| **Mod. 07** | [👉 TP 5 : Exploitation XSS & CSRF](./ateliers/05-xss-csrf-ssrf/README.md) | 20 min | DOMPurify, CSRF Tokens, SameSite Cookies |

---

## ✅ Checklist Déploiement Sécurisé

Avant tout passage en production, vous devez valider ces éléments :

- [ ] Toutes les entrées utilisateur sont validées et limitées côté serveur.
- [ ] Aucun secret (AWS, DB, Tokens) n'est présent dans le code source ou les variables d'URL.
- [ ] Les requêtes SQL utilisent des requêtes préparées/paramétrées.
- [ ] Les tokens JWT ont une date d'expiration stricte et courte.
- [ ] Le rate limiting est mis en place sur `/login` et autres actions sensibles.
- [ ] Les headers HTTP de sécurité sont configurés (CSP, HSTS, X-Frame-Options...).
- [ ] Les dépendances ont été auditées (`npm audit` / `pip-audit`).
- [ ] Le CORS utilise une *whitelist* précise de domaines.
