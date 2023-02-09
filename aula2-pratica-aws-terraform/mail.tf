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

resource "aws_s3_bucket" "s3_bucket" { # criando um bucket dentro do aws
  bucket = "teste-tcb10"
}

resource "aws_s3_bucket_public_access_block" "s3_block" { # alterando o modo de acesso ao bucket, transformando ele em um bucket com acesso privado
  bucket = aws_s3_bucket.s3_bucket.id
  
  block_public_acls = true
  block_public_policy = true
  ignore_public_acls = true # torna os arquivos dentro do bucket restrito
  restrict_public_buckets = true
  
}
