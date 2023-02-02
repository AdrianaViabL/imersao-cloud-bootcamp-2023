terraform {
  
  required_providers {
    aws = { 
        source = "hashicorp/aws"
        version = "~> 4.16"
    }
  }
  required_version = ">= 1.2.0"
  
}

provider "aws" {
     region = "us-west-2"
}

resource "aws_s3_bucket" "s3_bucket" { #criando um bucket dentro do aws
  bucket = "teste-tcb10"
}

