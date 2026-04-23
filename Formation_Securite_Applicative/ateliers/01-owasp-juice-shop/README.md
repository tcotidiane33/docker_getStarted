# Atelier 1 : Identifier les vulnérabilités OWASP dans une application cible

**Durée estimée :** 25 minutes  
**Type :** Attaque simulée (Pentest basique)

## 🎯 Objectif
S'entraîner à identifier les vulnérabilités majeures du **OWASP Top 10** dans une application sciemment vulnérable (OWASP Juice Shop).

---

## 🛠️ Instructions

### Étape 1 : Déployer l'environnement de test (Juice Shop)
OWASP Juice Shop est l'application moderne la plus célèbre pour l'apprentissage de la sécurité.
Assurez-vous d'avoir Docker installé et lancez :

```bash
docker run --rm -p 3000:3000 bkimminich/juice-shop
```
Ouvrez votre navigateur à l'adresse : `http://localhost:3000`

### Étape 2 : A03 - Injection SQL (SQLi)
Tentez de vous connecter en tant qu'administrateur **sans connaître son mot de passe**.
1. Allez sur la page de connexion.
2. Dans l'email, insérez la payload SQLi classique : `' OR 1=1--`
3. Mettez n'importe quel mot de passe et connectez-vous.
*Avez-vous réussi ? Pourquoi cette payload fonctionne-t-elle ?*

### Étape 3 : A03 / A07 - XSS Réfléchie (Cross-Site Scripting)
Trouvez comment injecter du code JavaScript dans le moteur de recherche.
1. Recherchez la chaîne suivante dans la barre de recherche : 
   `<iframe src="javascript:alert(`xss`)">`
2. Observez l'alerte. Comment le site pourrait-il s'en protéger ?

### Étape 4 : A01 - Broken Access Control
Essayez d’accéder à une section "protégée" de l'API sans être connecté.
1. Déconnectez-vous.
2. Dans la barre d'adresse de votre navigateur ou via Postman, accédez à :
   `http://localhost:3000/api/Users/`
*Que se passe-t-il ? Que révèle cette erreur de conception ?*

### Étape 5 : A05 - Security Misconfiguration (Headers)
Vérifiez l'absence de headers de défense sur l'application.
Ouvrez un terminal et tapez :

```bash
curl -I http://localhost:3000
```
*Identifiez quels headers de sécurité critiques sont manquants (ex: `Strict-Transport-Security`, `Content-Security-Policy`, `X-Frame-Options`).*

---

## 📝 Livrable attendu
Rédigez un court rapport listant les 4 failles identifiées. Pour chaque faille, ajoutez :
1. Sa catégorie OWASP Top 10.
2. La méthode pour la **corriger** dans le code.
