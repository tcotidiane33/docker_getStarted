# Atelier 3 : Implémentation d'une Authentification JWT Sécurisée

**Durée estimée :** 20 minutes  
**Type :** Rendu de code / Développement d'API

## 🎯 Objectif
Implémenter la gestion sécurisée (Best Practices) des tokens d'authentification sur une API REST fictive : Tokens courts, rotation des Refresh Tokens, et Rate Limiting.

---

## 🛠️ Instructions

### Étape 1 : Le duo Access Token & Refresh Token
Lorsqu'un utilisateur se connecte sur `POST /auth/login` :
1. Générez un **Access Token** JWT avec une courte expiration : `15 minutes`.
   - Il contiendra : `id` de l'utilisateur, `role=admin/user`.
   - Il sera renvoyé dans le corps (JSON) de la réponse.
2. Générez un **Refresh Token** (chaîne aléatoire cryptographique ou JWT long : 7 jours).
   - Ne le renvoyez **surtout pas** dans le JSON.
   - Injectez-le dans un `Set-Cookie` configuré en `HttpOnly`, `Secure` et `SameSite=Strict`.

*Concevez (pseudo-code ou script Node/Python) la fonction qui génère ceci.*

### Étape 2 : La rotation du Refresh Token
Implémentez la route `POST /auth/refresh` :
1. Elle lit le Refresh Token depuis les cookies.
2. Si le token est valide, l'API renvoie un *nouvel* Access Token.
3. Conséquence vitale : L'ancien Refresh Token est détruit, et un **nouveau** Refresh Token est généré dans un nouveau cookie (1 usage = 1 token). Ceci bloque le vol persistant.

### Étape 3 : Rate Limiting contre le Brute Force
L'authentification est la cible de credential stuffing. Ajoutez un mécanisme de rate limit.
- Limite : 5 requêtes par minute sur la route `/auth/login`.
- Pénalité : Lockout (blocage du compte par IP) pendant 15 minutes.

*(Si vous codez en Node.js, étudiez et intégrez la librairie `express-rate-limit`).*

### Étape 4 : Gestion de la Révocation (Blacklisting)
Un token JWT est "stateless" (il ne requiert pas la base de données pour être lu).
- Si l'utilisateur clique sur "Déconnexion", comment l'Access Token (encore valide 10 minutes) est-il invalidé côté Backend ?
- Réponse : Implémentez un **Redis** et stockez l'ID du JWT (`jti`) dans une *Blacklist* avec un TTL correspondant au temps de vie restant du token. Côté Authorization Middleware, vérifiez si l'Access Token apparaît dans cette Blacklist.

---

## 📝 Livrable attendu
Fournir un dépôt Git contenant l'architecture du routeur d'authentification (`auth.route.js` ou `auth.py`) respectant :
- Génération JWT < 15 min.
- Refresh Token en Cookie HttpOnly.
- Présence du middleware de Rate Limiting.
