provider "aws" {
  region = "ap-northeast-1"
}

terraform {
  backend "remote" {
    # The name of your Terraform Cloud organization.
    organization = "datluyendevops"

    # The name of the Terraform Cloud workspace to store Terraform state files in.
    workspaces {
      name = "example-workspace"
    }
  }
}

# An example resource that does nothing.
resource "null_resource" "example" {
  triggers = {
    value = "A example resource that does nothing!"
  }
}

# Init 1 DynamoDB table
resource "aws_dynamodb_table" "menu_database" {
  name           = "Menu_database"
  billing_mode   = "PROVISIONED"
  read_capacity  = 1
  write_capacity = 1
  hash_key       = "id"

  attribute {
    name = "id"
    type = "S"
  }

  ttl {
    attribute_name = ""
    enabled        = false
  }
}
