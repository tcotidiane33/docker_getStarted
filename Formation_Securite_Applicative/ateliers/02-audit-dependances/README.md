# Atelier 2 : Audit de Sécurité d'un projet existant

**Durée estimée :** 20 minutes  
**Type :** Analyse statique & Gestion des secrets

## 🎯 Objectif
Détecter les failles dans les dépendances (A06 - Vulnerable Components) et empêcher la fuite de secrets dans le gestionnaire de versions (Git).

---

## 🛠️ Instructions

### Étape 1 : Audit des dépendances (SCA)
Dans un projet Node.js existant (ou créez-en un via `npm init -y` et installez une vieille version express : `npm install express@4.10.0`) :

1. Entrez la commande d'audit :
   ```bash
   npm audit --audit-level=high
   ```
2. Lisez le rapport. Quelles sont les failles qui remontent ? Quelles sont leurs sévérités (CVSS) ?
3. Testez la résolution automatique :
   ```bash
   npm audit fix
   ```

### Étape 2 : Chasse aux secrets avec Git
Fouillez l'historique d'un projet pour trouver des secrets hardcodés accidentellement.

1. Initiez un repository et commitez un faux mot de passe dans un fichier :
   ```bash
   echo "AWS_KEY=AKIAIOSFODNN7EXAMPLE" > config.json
   git add config.json && git commit -m "add config"
   ```
2. Utilisez grep sur l'historique de Git :
   ```bash
   git log --all -p | grep -E -i 'password|secret|token|AKIA'
   ```
*Notez que même si vous effacez le fichier dans un futur commit, il reste gravé dans l'historique Git.*

### Étape 3 : Protection (Pre-commit hooks)
Mettre en place une protection pour empêcher les développeurs de commiter des secrets dans le futur.

1. Installer `husky` dans votre projet Node.js local :
   ```bash
   npm install husky --save-dev
   npx husky init
   ```
2. Ajoutez un script manuel de rejet si le mot "AWS_SECRET" est détecté lors du commit. Mettez ceci dans `.husky/pre-commit` :
   ```bash
   if git diff --cached | grep -qi "AWS_SECRET"; then
     echo "🚨 ALERTE SECURITE: Secret détecté dans le commit. Commit annulé."
     exit 1
   fi
   ```
3. Testez ! Essayez de commit un fichier avec le mot `AWS_SECRET`.

---

## 📝 Livrable attendu
- Capture d'écran du blocage de Husky lors de la tentative de commit d'un secret.
- Mettre en place d'un fichier `.env.example` propre et l'ajout de `.env` dans votre `.gitignore`.
