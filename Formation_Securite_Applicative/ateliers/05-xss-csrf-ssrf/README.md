# Atelier 5 : Simulation et Correction XSS & CSRF

**Durée estimée :** 20 minutes  
**Type :** Pentest Client-Side / Navigateur

## 🎯 Objectif
Comprendre les deux attaques client les plus répandues : Cross-Site Scripting (XSS) et Cross-Site Request Forgery (CSRF).

---

## 🛠️ Instructions

### Étape 1 : XSS Stockée (Stored XSS)
Reprenez l'OWASP Juice Shop sur `http://localhost:3000`.
1. Allez dans la section `Customer Feedback` (Commentaires).
2. Mettez le lien suivant en tant que commentaire :
   `<script>alert(document.cookie)</script>`
3. Soumettez le commentaire.
4. Revenez sur la page des retours. Le navigateur a exécuté le code stocké en base de données de manière persistante sur tous les visiteurs de cette page (les autres clients !)

**🔑 La Correction (DOMPurify)**
Dans un projet React, Vue ou Vanilla JS côté entreprise, comment résoudre ça ?
1. Toujours utiliser les mécanismes d'échappement par défaut des frameworks modernes (ex: interpolation `{}` en React au lieu de `dangerouslySetInnerHTML`).
2. Si vous devez générer du HTML pur, installez la librairie npm `dompurify` et purifiez la chaîne avant rendu : 
   `DOMPurify.sanitize('<script>alert("xss")</script>') // Rend une chaîne vide`

### Étape 2 : L'Attaque CSRF (Le faux site)
Le CSRF utilise votre session (cookie) existante contre vous, depuis un *autre* site Web.
1. Imaginez que vous êtes connecté à `banque.com`.
2. Sur HTML `attaque.com`, créez une page blanche qui va lancer discrètement l'action protégée :
   ```html
   <html>
     <body onload="document.forms[0].submit()">
       <form action="http://banque.com/api/virement" method="POST">
         <input type="hidden" name="to" value="AttaquantX" />
         <input type="hidden" name="amount" value="5000" />
       </form>
     </body>
   </html>
   ```
3. Si la victime ouvre ce fichier, le navigateur exécute le POST et y rattache le cookie de la victime, validant le virement sans interaction.

**🔑 La Correction du serveur : CSRF Token (Synchronizer Token Pattern)**
1. Côté serveur Backend (Node.js/Django), le serveur génère un **Token Crypto CSRF**.
2. Il transmet ce test au frontend. Et ne permet le `POST /api/virement` **que si** ce token secret spécifique est renvoyé avec la demande.
3. Le site pirate ne possède pas ce token et est bloqué.
4. *Correction Supplémentaire : Utilisez les cookies `SameSite=Lax` ou `SameSite=Strict`. Le navigateur refusera d'envoyer le cookie pour une requête Cross-origin POST, bloquant net l'attaque de base.*

---

## 📝 Livrable attendu
- Explication des attributs d'un Cookie de session défensif parfait (`HttpOnly`, `Secure`, `SameSite`).
- Démonstration JS d'un sanitize via la méthode DOMPurify.
