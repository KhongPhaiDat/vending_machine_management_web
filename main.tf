provider "aws" {
  region = "ap-northeast-1"
}

terraform {
  backend "s3" {
    bucket = "terraform-state-storage-datluyendevops"
    key    = "test"
    region = "ap-northeast-1"
  }
}


# Init 1 DynamoDB table
resource "aws_dynamodb_table" "menu_database" {
  name           = "test_database"
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
