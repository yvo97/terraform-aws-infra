# 🚀 Terraform AWS Infrastructure

[![Terraform](https://img.shields.io/badge/terraform-%235835CC.svg?style=for-the-badge&logo=terraform&logoColor=white)](https://www.terraform.io/)
[![AWS](https://img.shields.io/badge/AWS-%23FF9900.svg?style=for-the-badge&logo=amazon-aws&logoColor=white)](https://aws.amazon.com/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg?style=for-the-badge)](https://opensource.org/licenses/MIT)

Une infrastructure AWS complète et modulaire provisionnée avec Terraform, incluant VPC, instances EC2, Load Balancer et Security Groups pour des environnements de développement et production. Il implémente les bonnes pratiques du Cloud en matière de sécurité, haute disponibilité et gestion des coûts.


# Public Cible

- 🧑‍💻 Développeurs souhaitant déployer des applications

- 👨‍🔧 DevOps Engineers cherchant une base d'infrastructure

- 🏢 Startups ayant besoin d'une infrastructure scalable

- 🎓 Étudiants apprenant l'Infrastructure as Code







## 🏗️ Description

Ce projet Terraform provisionne une infrastructure AWS complète et modulaire comprenant :

- **VPC** avec sous-réseaux publics et privés
- **Instances EC2** pour les environnements de développement et production
- **Load Balancer** applicatif (ALB) avec health checks
- **Security Groups** configurés avec les bonnes pratiques
- **Internet Gateway** et tables de routage
- **Scripts d'automatisation** pour le déploiement et la destruction

## 🏛️ Architecture

### Diagramme d'Architecture

<p align="center"> <img src="./infra.png" alt="Schéma d'infrastructure" width="600"/> </p>

### Composants Déployés

## ☁️ Composants d'Infrastructure et Coûts Estimés

| Composant | Description | Coût Estimé |
| :--- | :--- | :--- |
| **VPC** | Réseau virtuel isolé | Gratuit |
| **2x EC2 Instances** | Serveurs web (dev/prod) | ~$15/mois |
| **Application Load Balancer** | Répartition de charge | ~$16/mois |
| **4x Sous-réseaux** | 2 publics + 2 privés | Gratuit |
| **Security Groups** | Règles de sécurité | Gratuit |
| **Internet Gateway** | Connexion Internet | Gratuit |





## ⚙️ Prérequis

- Outils Requis

- Terraform >= 1.0.0

- AWS CLI version 2

- Compte AWS avec permissions appropriées

- SSH Key Pair pour accéder aux instances


## 🔐 Backend Terraform (S3 + DynamoDB)

Ce projet utilise un **backend distant sécurisé**, séparé pour chaque
environnement :

### ✔ State stocké dans S3

### ✔ Verrouillage du state via DynamoDB

### ✔ Pas de conflit entre dev et prod

### ✔ Pratique professionnelle standard DevOps/SRE


## 🧩 Architecture du Backend

 | Environnement | Bucket S3                         | DynamoDB Table                          | Rôle                                                    |
|--------------|-----------------------------------|-----------------------------------------|---------------------------------------------------------|
| **dev**      | `terraform-state-dev` | `projectname-terraform-state-lock-dev`  | Stockage du state pour l’environnement de développement |
| **prod**     | `terraform-state-prod`| `projectname-terraform-state-lock-prod` | Stockage du state pour l’environnement de production    |


## 🔄 Fonctionnement

### 📌 Quand tu es dans `environments/dev` :

    terraform init
    terraform validate
    terraform apply

➡ Le state est stocké dans le bucket **dev**\
➡ Le lock est géré dans la table **dev**

### 📌 Quand tu es dans `environments/prod` :

    terraform init
    terraform validate
    terraform apply

➡ Le state est stocké dans le bucket **prod**\
➡ Le lock est géré dans la table **prod**

Cela garantit :

-   aucun conflit entre les environnements\
-   sécurité renforcée\
-   travail en équipe sans risque de corruption du state







## 📁 Structure du Projet




<p align="center"> <img src="./arbo.png" alt="Schéma d'infrastructure" width="600"/> </p>





## 🚀 Workflows de Déploiement

1️⃣  Cloner le repository
     git clone https://github.com/ton-utilisateur/terraform-aws-infra.git
     cd terraform-aws-infra

2️⃣  Configurer les variables
     - Copier le fichier `terraform.tfvars.example` vers `terraform.tfvars`
     - Modifier les valeurs selon ton environnement

3️⃣  Créer la Key Pair AWS
     - Créer une clé dans la console AWS (ex: Terraform.pem)
     - Placer son nom dans `variables.tf` ou `terraform.tfvars`

4️⃣  Se positionner sur l’environnement cible
     cd environments/dev    # ou cd environments/prod

5️⃣  Initialiser Terraform
     terraform init

6️⃣  Valider la configuration
     terraform validate

7️⃣  Appliquer le déploiement
     terraform apply -auto-approve

8️⃣  Supprimer l’infrastructure (si nécessaire)
     terraform destroy -auto-approve






## 🔒 Sécurité

Bonnes Pratiques Implémentées

✅ Isolation réseau - Instances dans des sous-réseaux privés

✅ Security Groups restrictifs - Règles minimales nécessaires

✅ Pas d'IPs publiques sur les instances backend

✅ Accès SSH restreint - Seulement depuis le LB

✅ Load Balancer sécurisé - Terminaison TLS possible

✅ Tags de sécurité - Identification claire des ressources




```bash
terraform-aws-infra/
│
├── README.md                           # Documentation principale
├── .gitignore                          # Fichiers à ignorer par Git
├── LICENSE                             # Licence du projet
│
├── backend/                            # Configuration Backend S3 Remote
│   ├── main.tf                         # Création buckets S3 + tables DynamoDB
│   ├── variables.tf                    # Variables pour dev/prod
│   ├── outputs.tf                      # Outputs des ressources backend
│   └──
│
├── environments/
│   ├── dev/                            # Environnement développement
│   │   ├── main.tf                     # Configuration infrastructure dev
│   │   ├── backend.tf                  # Backend S3 spécifique à dev
│   │   ├── providers.tf                # Providers Terraform
│   │   ├── variables.tf                # Variables environnement dev
│   │   ├── outputs.tf                  # Outputs spécifiques dev
│   │   └── terraform.tfvars            # Valeurs variables dev
│   │
│   └── prod/                           # Environnement production
│       ├── main.tf                     # Configuration infrastructure prod
│       ├── backend.tf                  # Backend S3 spécifique à prod
│       ├── providers.tf                # Providers Terraform
│       ├── variables.tf                # Variables environnement prod
│       ├── outputs.tf                  # Outputs spécifiques prod
│       └── terraform.tfvars            # Valeurs variables prod
│
└── modules/                            # Modules Terraform réutilisables
    ├── vpc/                            # Module VPC
    │   ├── main.tf                     # VPC, subnets, IGW, route tables
    │   ├── variables.tf                # Variables module VPC
    │   └── outputs.tf                  # Outputs module VPC
    │
    ├── ec2/                            # Module EC2
    │   ├── main.tf                     # Instances EC2, AMI, userdata
    │   ├── variables.tf                # Variables module EC2
    │   └── outputs.tf                  # Outputs module EC2
    │
    └── security_groups/                # Module Security Groups
        ├── main.tf                     # Security Groups rules
        ├── variables.tf                # Variables module SG
        └── outputs.tf                  # Outputs module SG
