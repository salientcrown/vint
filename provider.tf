terraform {
  required_version = ">= 1.2.0"

  #   backend "s3" {
  #     bucket         = "silvercrossing"
  #     dynamodb_table = "terra"
  #     key            = "myenaj.tfstate"
  #     region         = "us-east-1"
  #     # encrypt        = "true"
  #   }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.34"
    }
  }
}

provider "aws" {
  region = "us-east-1"

}