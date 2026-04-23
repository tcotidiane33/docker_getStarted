# 🛠️ Outils Open Source pour IaC - Guide Complet

## 📖 Introduction

Ce guide présente l'écosystème complet des outils open source pour l'Infrastructure as Code, organisés par catégorie avec des cas d'usage concrets.

---

## 🏗️ Catégorie 1 : Provisioning (Créer l'Infrastructure)

### 1. Terraform ⭐ **LE PLUS POPULAIRE**

**License :** Mozilla Public License 2.0 (MPL 2.0)  
**Créateur :** HashiCorp  
**Langage :** Go  
**Site :** https://www.terraform.io

#### Pourquoi Terraform ?
- ✅ **Multi-cloud** : AWS, Azure, GCP, DigitalOcean, etc.
- ✅ **Déclaratif** : Vous décrivez ce que vous voulez
- ✅ **État** : Garde en mémoire ce qui existe
- ✅ **Écosystème** : 2000+ providers disponibles

#### Cas d'usage
```hcl
# Exemple : Infrastructure multi-cloud
provider "aws" {
  region = "eu-west-1"
}

provider "digitalocean" {
  token = var.do_token
}

# Serveurs web sur AWS (moins cher)
resource "aws_instance" "web" {
  count = 3
  # ...
}

# Bases de données sur DigitalOcean (simplicité)
resource "digitalocean_database_cluster" "postgres" {
  name = "db-cluster"
  # ...
}
```

#### Alternatives Open Source

**OpenTofu** (Fork de Terraform)
- **License :** MPL 2.0
- **Site :** https://opentofu.org
- **Pourquoi :** Alternative 100% open source après changement de license Terraform
- **Compatible :** Drop-in replacement de Terraform

```bash
# Installation OpenTofu
brew install opentofu

# Utilisation identique à Terraform
tofu init
tofu plan
tofu apply
```

### 2. Pulumi

**License :** Apache 2.0  
**Langage :** TypeScript, Python, Go, C#, Java  
**Site :** https://www.pulumi.com

#### Pourquoi Pulumi ?
- ✅ Écrire l'IaC dans de vrais langages de programmation
- ✅ Boucles, conditions, fonctions natives
- ✅ Réutiliser l'écosystème npm, pip, etc.

#### Exemple
```python
# pulumi_example.py
import pulumi
import pulumi_aws as aws

# Utilisation de Python natif
for i in range(3):
    server = aws.ec2.Instance(f"web-{i}",
        instance_type="t2.micro",
        ami="ami-xxxxx"
    )
    
    pulumi.export(f"server_{i}_ip", server.public_ip)
```

### 3. CloudFormation (AWS)

**License :** Propriétaire AWS (gratuit)  
**Format :** YAML/JSON  
**Site :** https://aws.amazon.com/cloudformation/

#### Pourquoi CloudFormation ?
- ✅ Natif AWS (pas d'installation)
- ✅ Intégré à tous les services AWS
- ✅ Gratuit (vous payez seulement les ressources)

#### Exemple
```yaml
# template.yaml
Resources:
  WebServer:
    Type: AWS::EC2::Instance
    Properties:
      InstanceType: t2.micro
      ImageId: ami-xxxxx
```

### 4. Bicep (Azure)

**License :** MIT  
**Format :** DSL spécifique  
**Site :** https://github.com/Azure/bicep

#### Pourquoi Bicep ?
- ✅ Alternative simplifiée à ARM templates
- ✅ Syntaxe plus lisible
- ✅ Natif Azure

```bicep
// main.bicep
resource vm 'Microsoft.Compute/virtualMachines@2021-03-01' = {
  name: 'myVM'
  location: 'eastus'
  properties: {
    hardwareProfile: {
      vmSize: 'Standard_B2s'
    }
  }
}
```

---

## ⚙️ Catégorie 2 : Configuration Management

### 1. Ansible ⭐ **LE PLUS SIMPLE**

**License :** GPL v3  
**Créateur :** Red Hat  
**Langage :** Python  
**Site :** https://www.ansible.com

#### Pourquoi Ansible ?
- ✅ **Agentless** : Pas d'installation sur les serveurs cibles
- ✅ **Simple** : YAML facile à lire
- ✅ **Modules** : 5000+ modules disponibles
- ✅ **Communauté** : Ansible Galaxy (roles partagés)

#### Exemple concret
```yaml
# playbook.yml
---
- name: Installer stack LAMP
  hosts: webservers
  become: yes
  
  tasks:
    - name: Installer Apache, MySQL, PHP
      apt:
        name:
          - apache2
          - mysql-server
          - php
          - libapache2-mod-php
        state: present
        update_cache: yes
    
    - name: Démarrer Apache
      service:
        name: apache2
        state: started
        enabled: yes
```

### 2. Chef

**License :** Apache 2.0  
**Langage :** Ruby  
**Site :** https://www.chef.io

#### Pourquoi Chef ?
- ✅ Puissant pour les configurations complexes
- ✅ Infrastructure as Code pure (Ruby DSL)
- ✅ Test Kitchen pour tester les recettes

```ruby
# cookbook/recipes/default.rb
package 'nginx' do
  action :install
end

service 'nginx' do
  action [:enable, :start]
end

template '/etc/nginx/nginx.conf' do
  source 'nginx.conf.erb'
  notifies :reload, 'service[nginx]'
end
```

### 3. Puppet

**License :** Apache 2.0  
**Langage :** DSL propriétaire  
**Site :** https://puppet.com

#### Pourquoi Puppet ?
- ✅ Déclaratif pur
- ✅ Bon pour grandes infrastructures
- ✅ Rapports détaillés

```puppet
# manifests/site.pp
class webserver {
  package { 'nginx':
    ensure => present,
  }
  
  service { 'nginx':
    ensure  => running,
    enable  => true,
    require => Package['nginx'],
  }
}
```

### 4. SaltStack

**License :** Apache 2.0  
**Langage :** Python  
**Site :** https://saltproject.io

#### Pourquoi Salt ?
- ✅ Très rapide (event-driven)
- ✅ Python natif
- ✅ Remote execution puissant

```yaml
# salt/nginx/init.sls
nginx:
  pkg.installed: []
  service.running:
    - enable: True
    - require:
      - pkg: nginx
```

---

## 🐳 Catégorie 3 : Conteneurisation & Orchestration

### 1. Docker ⭐ **INCONTOURNABLE**

**License :** Apache 2.0  
**Site :** https://www.docker.com

#### Pourquoi Docker ?
- ✅ Portabilité : "Works on my machine" → "Works everywhere"
- ✅ Isolation des applications
- ✅ Écosystème énorme (Docker Hub)

```dockerfile
# Dockerfile
FROM ubuntu:22.04

RUN apt-get update && \
    apt-get install -y nginx

COPY index.html /var/www/html/

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
```

```yaml
# docker-compose.yml
version: '3.8'

services:
  web:
    image: nginx:latest
    ports:
      - "80:80"
    volumes:
      - ./html:/usr/share/nginx/html
  
  db:
    image: postgres:15
    environment:
      POSTGRES_PASSWORD: secretpassword
    volumes:
      - db-data:/var/lib/postgresql/data

volumes:
  db-data:
```

### 2. Kubernetes (K8s) ⭐ **L'ORCHESTRATEUR**

**License :** Apache 2.0  
**Créateur :** Google (maintenant CNCF)  
**Site :** https://kubernetes.io

#### Pourquoi Kubernetes ?
- ✅ Orchestration de conteneurs à grande échelle
- ✅ Auto-healing, auto-scaling
- ✅ Standard de l'industrie

```yaml
# deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deployment
spec:
  replicas: 3
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
      - name: nginx
        image: nginx:1.24
        ports:
        - containerPort: 80
```

#### Distributions Kubernetes Open Source

**K3s** (Lightweight Kubernetes)
```bash
# Installation ultra-simple
curl -sfL https://get.k3s.io | sh -

# Un cluster K8s en 30 secondes !
```

**MicroK8s** (Canonical)
```bash
# Installation
snap install microk8s --classic

# Démarrage rapide
microk8s start
microk8s kubectl get nodes
```

**Minikube** (Pour le dev local)
```bash
# Installation
brew install minikube

# Lancer un cluster local
minikube start

# Dashboard
minikube dashboard
```

### 3. Podman

**License :** Apache 2.0  
**Site :** https://podman.io

#### Pourquoi Podman ?
- ✅ Alternative à Docker (compatible)
- ✅ Daemonless (plus sécurisé)
- ✅ Rootless containers

```bash
# Syntaxe identique à Docker
podman run -d -p 80:80 nginx

# Génération de YAML Kubernetes
podman generate kube mynginx > mynginx.yaml
```

---

## 🔄 Catégorie 4 : CI/CD

### 1. GitLab CI/CD

**License :** MIT  
**Site :** https://about.gitlab.com

#### Exemple Pipeline IaC
```yaml
# .gitlab-ci.yml
stages:
  - validate
  - plan
  - apply

terraform_validate:
  stage: validate
  script:
    - terraform init
    - terraform validate
    - terraform fmt -check

terraform_plan:
  stage: plan
  script:
    - terraform init
    - terraform plan -out=plan.tfplan
  artifacts:
    paths:
      - plan.tfplan

terraform_apply:
  stage: apply
  script:
    - terraform apply plan.tfplan
  when: manual
  only:
    - main
```

### 2. Jenkins

**License :** MIT  
**Site :** https://www.jenkins.io

```groovy
// Jenkinsfile
pipeline {
    agent any
    
    stages {
        stage('Terraform Init') {
            steps {
                sh 'terraform init'
            }
        }
        
        stage('Terraform Plan') {
            steps {
                sh 'terraform plan -out=tfplan'
            }
        }
        
        stage('Terraform Apply') {
            when {
                branch 'main'
            }
            steps {
                sh 'terraform apply tfplan'
            }
        }
    }
}
```

### 3. GitHub Actions

**License :** Gratuit pour open source  
**Site :** https://github.com/features/actions

```yaml
# .github/workflows/terraform.yml
name: Terraform CI/CD

on:
  push:
    branches: [main]
  pull_request:

jobs:
  terraform:
    runs-on: ubuntu-latest
    
    steps:
      - uses: actions/checkout@v3
      
      - name: Setup Terraform
        uses: hashicorp/setup-terraform@v2
      
      - name: Terraform Init
        run: terraform init
      
      - name: Terraform Plan
        run: terraform plan
      
      - name: Terraform Apply
        if: github.ref == 'refs/heads/main'
        run: terraform apply -auto-approve
```

### 4. Drone CI

**License :** Apache 2.0  
**Site :** https://www.drone.io

```yaml
# .drone.yml
kind: pipeline
type: docker
name: default

steps:
  - name: terraform
    image: hashicorp/terraform
    commands:
      - terraform init
      - terraform plan
      - terraform apply -auto-approve
```

---

## 🛡️ Catégorie 5 : Sécurité & Compliance

### 1. Checkov

**License :** Apache 2.0  
**Site :** https://www.checkov.io

#### Scanne vos fichiers IaC pour les vulnérabilités

```bash
# Installation
pip install checkov

# Scanner Terraform
checkov -d ./terraform

# Scanner Ansible
checkov -f playbook.yml

# Exemple de sortie
Check: CKV_AWS_8: "Ensure all data stored in the S3 bucket is securely encrypted at rest"
	FAILED for resource: aws_s3_bucket.example
```

### 2. tfsec

**License :** MIT  
**Site :** https://github.com/aquasecurity/tfsec

```bash
# Installation
brew install tfsec

# Scanner
tfsec .

# Exemple de problème détecté
Problem 1
  [AWS003][WARNING] AWS Classic resource usage
```

### 3. Terrascan

**License :** Apache 2.0  
**Site :** https://runterrascan.io

```bash
# Scanner multiple IaC formats
terrascan scan -t terraform
terrascan scan -t kubernetes
terrascan scan -t helm
```

### 4. Open Policy Agent (OPA)

**License :** Apache 2.0  
**Site :** https://www.openpolicyagent.org

#### Policy as Code

```rego
# policy.rego
package terraform.analysis

deny[msg] {
    resource := input.resource_changes[_]
    resource.type == "aws_s3_bucket"
    not resource.change.after.encryption
    
    msg := sprintf(
        "S3 bucket '%s' must have encryption enabled",
        [resource.name]
    )
}
```

---

## 📊 Catégorie 6 : Monitoring & Observability

### 1. Prometheus + Grafana

**License :** Apache 2.0  
**Sites :** 
- https://prometheus.io
- https://grafana.com

```yaml
# docker-compose.yml monitoring stack
version: '3'

services:
  prometheus:
    image: prom/prometheus:latest
    volumes:
      - ./prometheus.yml:/etc/prometheus/prometheus.yml
    ports:
      - "9090:9090"
  
  grafana:
    image: grafana/grafana:latest
    ports:
      - "3000:3000"
    environment:
      - GF_SECURITY_ADMIN_PASSWORD=admin
```

### 2. ELK Stack (Elasticsearch, Logstash, Kibana)

**License :** Elastic License / SSPL  
**Site :** https://www.elastic.co

```yaml
# Configuration Logstash
input {
  file {
    path => "/var/log/nginx/access.log"
  }
}

filter {
  grok {
    match => { "message" => "%{COMBINEDAPACHELOG}" }
  }
}

output {
  elasticsearch {
    hosts => ["localhost:9200"]
  }
}
```

### 3. Netdata

**License :** GPL v3  
**Site :** https://www.netdata.cloud

```bash
# Installation en 1 commande
bash <(curl -Ss https://my-netdata.io/kickstart.sh)

# Monitoring instantané de 2000+ métriques
# Dashboard automatique sur http://localhost:19999
```

---

## 🧪 Catégorie 7 : Testing

### 1. Terratest

**License :** Apache 2.0  
**Langage :** Go  
**Site :** https://terratest.gruntwork.io

```go
// test/terraform_test.go
package test

import (
    "testing"
    "github.com/gruntwork-io/terratest/modules/terraform"
    "github.com/stretchr/testify/assert"
)

func TestTerraformWebServer(t *testing.T) {
    terraformOptions := &terraform.Options{
        TerraformDir: "../",
    }
    
    defer terraform.Destroy(t, terraformOptions)
    
    terraform.InitAndApply(t, terraformOptions)
    
    instanceIP := terraform.Output(t, terraformOptions, "instance_ip")
    assert.NotEmpty(t, instanceIP)
}
```

### 2. Molecule (pour Ansible)

**License :** MIT  
**Site :** https://molecule.readthedocs.io

```bash
# Initialiser Molecule pour un role
molecule init role my-role

# Tester le role
molecule test

# Sequence de test:
# 1. Lint
# 2. Create (lancer un conteneur)
# 3. Converge (exécuter le role)
# 4. Verify (tests)
# 5. Destroy
```

### 3. InSpec

**License :** Apache 2.0  
**Site :** https://www.inspec.io

```ruby
# test/integration/default/controls/nginx_spec.rb
describe package('nginx') do
  it { should be_installed }
end

describe service('nginx') do
  it { should be_running }
  it { should be_enabled }
end

describe port(80) do
  it { should be_listening }
end
```

---

## 📦 Catégorie 8 : Secrets Management

### 1. HashiCorp Vault

**License :** MPL 2.0  
**Site :** https://www.vaultproject.io

```bash
# Démarrage rapide
vault server -dev

# Stocker un secret
vault kv put secret/database password="MySuperSecretPassword"

# Récupérer un secret
vault kv get secret/database
```

**Intégration Terraform :**
```hcl
data "vault_generic_secret" "db_password" {
  path = "secret/database"
}

resource "aws_db_instance" "main" {
  password = data.vault_generic_secret.db_password.data["password"]
}
```

### 2. SOPS (Secrets OPerationS)

**License :** MPL 2.0  
**Site :** https://github.com/mozilla/sops

```bash
# Chiffrer un fichier
sops -e secrets.yaml > secrets.enc.yaml

# Déchiffrer
sops -d secrets.enc.yaml
```

### 3. Sealed Secrets (Kubernetes)

**License :** Apache 2.0  
**Site :** https://github.com/bitnami-labs/sealed-secrets

```bash
# Sceller un secret
echo -n "mysecretpassword" | kubectl create secret generic mysecret \
  --dry-run=client --from-file=password=/dev/stdin -o yaml | \
  kubeseal -o yaml > mysealedsecret.yaml

# Le fichier peut être commité dans Git !
```

---

## 🎯 Tableau Comparatif : Choisir le Bon Outil

| Besoin | Outil Recommandé | Alternative |
|--------|------------------|-------------|
| Provisionner multi-cloud | Terraform | OpenTofu, Pulumi |
| Provisionner AWS only | CloudFormation | Terraform |
| Provisionner Azure only | Bicep | Terraform |
| Configurer serveurs (simple) | Ansible | SaltStack |
| Configurer serveurs (complexe) | Chef | Puppet |
| Conteneurs dev/test | Docker | Podman |
| Orchestration production | Kubernetes | Docker Swarm |
| CI/CD auto-hébergé | GitLab | Jenkins |
| CI/CD cloud | GitHub Actions | - |
| Scanner sécurité IaC | Checkov | tfsec, Terrascan |
| Secrets management | Vault | SOPS |
| Testing Terraform | Terratest | - |
| Testing Ansible | Molecule | - |
| Monitoring | Prometheus+Grafana | Netdata |
| Logs | ELK Stack | Loki+Grafana |

---

## 🚀 Stack Complète Open Source Recommandée

```
┌─────────────────────────────────────────┐
│           Git Repository                 │
│          (GitHub/GitLab)                │
└──────────────┬──────────────────────────┘
               │
               ▼
┌─────────────────────────────────────────┐
│          CI/CD Pipeline                  │
│      (GitHub Actions/GitLab CI)         │
│  - Lint (tflint, ansible-lint)          │
│  - Security Scan (Checkov, tfsec)       │
│  - Tests (Terratest, Molecule)          │
└──────────────┬──────────────────────────┘
               │
         ┌─────┴─────┐
         │           │
         ▼           ▼
┌─────────────┐  ┌──────────────┐
│  Terraform  │  │   Ansible    │
│  (OpenTofu) │  │              │
│             │  │              │
│ Provision   │  │ Configure    │
└──────┬──────┘  └──────┬───────┘
       │                │
       └────────┬───────┘
                │
                ▼
┌─────────────────────────────────────────┐
│         Infrastructure                   │
│    (AWS/Azure/GCP/On-Prem)              │
│                                          │
│  - Kubernetes (K3s/MicroK8s)            │
│  - Docker containers                    │
│  - Monitoring (Prometheus+Grafana)      │
│  - Logging (ELK/Loki)                   │
│  - Secrets (Vault)                      │
└─────────────────────────────────────────┘
```

---

## 📚 Ressources pour Chaque Outil

Voir le fichier complet avec liens vers documentation, tutoriels et communautés!

**Prochaine étape :** Choisissez un outil et commencez à pratiquer ! 🎉
