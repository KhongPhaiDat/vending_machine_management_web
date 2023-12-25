provider "aws" {
  region = "ap-northeast-1"
}

# An example resource that does nothing.
resource "null_resource" "example" {
  triggers = {
    value = "A example resource that does nothing!"
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
