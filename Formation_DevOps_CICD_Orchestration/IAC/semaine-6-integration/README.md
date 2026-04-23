# Semaine 6 : Intégration Terraform + Ansible & CI/CD Pipeline

## 🎯 Objectifs d'Apprentissage

À la fin de cette semaine, vous serez capable de :
- ✅ Combiner Terraform et Ansible pour provisionner ET configurer de bout en bout
- ✅ Générer un inventaire Ansible dynamique à partir des outputs Terraform
- ✅ Auditer la sécurité de votre code avec Checkov ou tfsec
- ✅ Automatiser vos déploiements d'infrastructure complets dans une CI/CD (GitHub Actions / GitLab CI)

---

## 📚 Les Exercices Pratiques

### Exercice 16 - Le Couplage Terraform + Ansible
**Durée estimée :** 3 heures | **Niveau :** Avancé

Il y a deux méthodes principales pour coupler TF et Ansible:
1. Utiliser un **provisioner "local-exec"** dans Terraform.
2. *(Recommandé)* Utiliser `terraform output` pour nourrir Ansible ou écrire un inventaire local généré par Terraform (le `local_file` avec un `templatefile`).

```bash
# Dans Terraform, on génère l'inventaire Ansible à la volée !
cat > inventory.tmpl << 'EOF'
[webservers]
%{ for ip in web_ips ~}
${ip}
%{ endfor ~}

[all:vars]
ansible_user=ubuntu
ansible_ssh_private_key_file=~/.ssh/maclé.pem
EOF

cat > outputs.tf << 'EOF'
resource "local_file" "ansible_inventory" {
  content = templatefile("${path.module}/inventory.tmpl", {
    web_ips = aws_instance.web[*].public_ip
  })
  filename = "../ansible/inventory.ini"
}
EOF

# Action :
# 1. terraform apply -auto-approve (Provisionnement)
# 2. L'inventaire "../ansible/inventory.ini" est généré.
# 3. ansible-playbook -i ../ansible/inventory.ini site.yml (Configuration)
```

### Exercice 17 - Audit de Sécurité Infrastructure as Code
**Durée estimée :** 1 heure | **Niveau :** Avancé

Avant d'approver l'infra, vérifions les failles de sécurité avec Checkov (Scan statique).

```bash
# Installation
pip install checkov

# Détection de failles sur le répertoire terraform/
checkov -d ./terraform-project

# Exemple de faille détectée : CKV_AWS_8 (Ensure all data stored in the default EBS is securely encrypted)
```

### Exercice 18 - Le Pipeline CI/CD GitOps
**Durée estimée :** 3 heures | **Niveau :** Avancé

On met tout bout à bout en écrivant un fichier GitLab CI (`.gitlab-ci.yml`) ou GitHub Actions (`.github/workflows/deploy.yml`).

Le workflow classique :
1. Les développeurs poussent du code sur une PR/Merge Request.
2. Le pipeline s'active :
   - Formate le code (`fmt`)
   - Analyse de sécurité (`checkov`)
   - Génère un plan de prévision (`plan`) et le commente dans la PR.
3. Un admin relève la PR et fait le "Merge" sur la branche `main`.
4. Le pipeline repart sur le build final sur `main` :
   - `terraform apply -auto-approve`
   - `ansible-playbook ...` pour configurer le code déployé.

*(Référez-vous à l'Exemple "EXAMPLE/infrastructure/ci-cd/" dans le cours pour voir des templates complets).*

### Projet Final - Application Complète (Capstone Project)
**Durée estimée :** 6-8 heures | **Niveau :** Expert

Mettez toutes vos connaissances en œuvre dans un seul grand repo :
- **Réseau :** VPC AWS dédié complet.
- **Ressources Cibles :** 2 serveurs exposés via Load Balancer. Une base de données managée RDS.
- **Ansible :** Formaté en rôles. Il installe le logiciel sur les instances provisionnées.
- **Opérations :** Tout est lancé via un trigger Push sur GitLab ou GitHub. Aucune action manuelle autorisée (sauf confirmation CI).

---

## 📝 Checklist de Progression Finale

- [ ] L'infrastructure est 100% reproductible sans clics humains dans une console cloud.
- [ ] Le state Terraform est conservé de façon distante et verrouillé.
- [ ] Les serveurs déploient leur configuration applicative tout seuls via Ansible.
- [ ] Mon code est scanné à la recherche de clefs AWS écrites en clair.
- [ ] Le cycle de vie est versionné et packagé en CI/CD (GitOps formel).

---

## 🎉 Félicitations !
Vous avez complété le parcours IaC complet !
Vous êtes maintenant capable de provisionner n'importe quelle infrastructure cloud de manière auditable et automatisée.
