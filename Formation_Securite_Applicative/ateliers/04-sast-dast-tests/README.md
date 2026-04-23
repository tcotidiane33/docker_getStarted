# Atelier 4 : Audit de sécurité SAST & DAST

**Durée estimée :** 20 minutes  
**Type :** Analyse automatisée d'applications (DevSecOps)

## 🎯 Objectif
Séparer les approches complémentaires de détection des failles : 
L'Analyse statique du code source (SAST) et l'Analyse dynamique du serveur (DAST).

---

## 🛠️ Instructions

### Étape 1 : Focus SAST avec SonarQube (Static Application Security Testing)
SonarQube va lire votre code sans l'exécuter pour y trouver des vulnérabilités (ex: utilisation de mots de passe hardcodés).

1. Lancer SonarQube en local :
   ```bash
   docker run -d --name sonarqube -e SONAR_ES_BOOTSTRAP_CHECKS_DISABLE=true -p 9000:9000 sonarqube:latest
   ```
2. Allez sur `http://localhost:9000` (admin/admin).
3. Connectez un projet de développement que vous possédez, générez un token.
4. Lancez le scanner Sonar (par exemple avec `sonar-scanner`) sur votre dossier existant.
5. Observez la section **Security Hotspots** & **Vulnerability** du rapport.

### Étape 2 : Focus DAST avec OWASP ZAP (Dynamic Application Security Testing)
ZAP va interagir avec l'application via le réseau en tentant de l'attaquer.

1. Identifiez une URL locale à attaquer (ex: Juice Shop vue à l'Atelier 1 sur http://localhost:3000).
2. Lancez le scanner officiel OWASP ZAP via Docker (en mode headless pour un scan passif "baseline") :
   ```bash
   docker run -t owasp/zap2docker-stable zap-baseline.py -t http://172.17.0.1:3000
   ```
   *(Pensez à remplacer 172.17.0.1 par l'IP réseau de votre host, localhost ne marchant pas de container à container sans réseau rattaché).*

3. Observez la sortie console du pentest automatisé (Alerte sur les headers X-Content-Type-Options manquant, CSRF Token manquant, etc).

### Étape 3 : Shift-Left "Quality Gate" dans GitLab / GitHub CI/CD
Comprendre la théorie de l'automatisation :
- Pourquoi intégrer le SAST à chaque *Pull Request* (Merge Request) et bloquer le pipeline ?
- Pourquoi intégrer le DAST uniquement sur l'environnement de *Staging / PreProd* ?

---

## 📝 Livrable attendu
Rapport écrit pour un DSI / CTO priorisant **3 failles trouvées**.
Pour chaque faille trouvée dans l'audit automatisé :
1. Décrire la faille.
2. Expliquer comment on la corrige.
3. Estimer le temps d'effort de la correction.
