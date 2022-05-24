terraform {
  required_providers {
// ashicorp/aws v4.13.0 // es recomana deixar constancia de la última versió funcional
    aws = {
      source = "hashicorp/aws"
    }
  }
}

provider "aws" {
  region                   = "us-west-2"
  shared_credentials_files = ["~/.aws/credentials"]  //aqui IAM amb els privilegis justos i la ruta
  //profile                  = "admin"
  profile                  = "fornesIAM"
}