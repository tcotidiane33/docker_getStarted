# Atelier 2 : Déploiement sur Kubernetes Local (Minikube)

**Durée estimée :** 60 minutes  
**Type :** Orchestration & YAML

## 🎯 Objectif
Migrer de Docker Compose vers un véritable orchestrateur de production. Déclarer l'état souhaité de l'application via des Manifests Kubernetes (Deployment, Service).

---

## 🛠️ Instructions

### Étape 1 : Démarrer Minikube
Assurez-vous que Docker est lancé, puis initiez votre cluster local :
```bash
minikube start
kubectl get nodes
```
*Le statut du nœud minikube doit être "Ready".*

### Étape 2 : Créer le Deployment (Les Pods)
Créez un fichier `deployment.yaml` pour déployer une brique Nginx de démonstration (pour s'épargner le build de l'app Node sur K8s local).
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deployment
spec:
  replicas: 3
  selector:
    matchLabels:
      app: nginx-web
  template:
    metadata:
      labels:
        app: nginx-web
    spec:
      containers:
      - name: nginx
        image: nginx:1.21-alpine
        ports:
        - containerPort: 80
```

Appliquez la configuration au cluster et observez la création des Pods :
```bash
kubectl apply -f deployment.yaml
kubectl get pods -w
```
*(Vous devriez voir 3 Pods en train de démarrer, correspondant aux `replicas: 3`).*

### Étape 3 : Créer le Service (Réseau et Load Balancing)
Les Pods sont éphémères. S'ils meurent, leur IP change. Un `Service` fournit une IP stable et répartit la charge.

Créez un `service.yaml` :
```yaml
apiVersion: v1
kind: Service
metadata:
  name: nginx-service
spec:
  type: NodePort
  selector:
    app: nginx-web # Doit matcher les labels du Deployment !
  ports:
    - port: 80
      targetPort: 80
      nodePort: 30080
```

Appliquez et testez :
```bash
kubectl apply -f service.yaml
minikube service nginx-service
```

### Étape 4 : Test de résilience (L'Auto-Healing)
L'intérêt majeur de Kubernetes est sa capacité d'auto-réparation.
1. Affichez vos pods (`kubectl get pods`).
2. Supprimez brutalement un pod en utilisant son nom (`kubectl delete pod <NOM_DU_POD>`).
3. Refaites rapidement un `kubectl get pods`. *Regardez : K8s a immédiatement recréé un nouveau Pod pour maintenir l'état déclaré de `replicas: 3` !*

---

## 📝 Livrable attendu
- Les deux fichiers YAML correctement formatés.
- Connaissance de commande `kubectl get pods` et compréhension de l'effet "Auto-healing" en cas de perte de composant.
