variable "aws_region" {
  description = "Région AWS pour le backend S3"
  type        = string
  default     = "us-east-1"
}



variable "environments" {
  description = "Liste des environnements pour lesquels créer un backend S3"
  type        = list(string)
  default     = ["dev", "prod"]
}

variable "project_name" {
  description = "Nom du projet pour le préfixe des ressources"
  type        = string
  default     = "infrodoctor"
}