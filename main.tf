provider "aws" {
  region = "ap-northeast-1"
}
# Init storage for tfstate file for multilple devs working
terraform {
  backend "s3" {
    bucket         = "terraform-state-storage-datluyendevops"
    key            = "vending-machine-management/terraform.tfstate"
    region         = "ap-northeast-1"
    dynamodb_table = "terraform-lock-state"
    encrypt        = true
  }
}

resource "aws_s3_bucket" "terraform_state" {
  bucket = "terraform-state-storage-datluyendevops"
  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_s3_bucket_versioning" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_dynamodb_table" "terraform_lock_state" {
  name         = "terraform-lock-state"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
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
# Init 1 Item in DynamoDB table for testing
resource "aws_dynamodb_table_item" "example" {
  table_name = aws_dynamodb_table.menu_database.name
  hash_key   = aws_dynamodb_table.menu_database.hash_key

  item = <<ITEM
  {
  "id": {
    "S": "ua3dXFyQwMSMzvzEC"
  },
  "items": {
    "M": {
      "bento": {
        "M": {
          "amount": {
            "N": "10"
          },
          "price": {
            "N": "10"
          }
        }
      },
      "chocolate": {
        "M": {
          "amount": {
            "N": "10"
          },
          "price": {
            "N": "10"
          }
        }
      },
      "coffee": {
        "M": {
          "amount": {
            "N": "10"
          },
          "price": {
            "N": "10"
          }
        }
      },
      "cupcake": {
        "M": {
          "amount": {
            "N": "10"
          },
          "price": {
            "N": "10"
          }
        }
      },
      "dat": {
        "M": {
          "amount": {
            "N": "0"
          },
          "price": {
            "N": "0"
          }
        }
      },
      "dried_fruits": {
        "M": {
          "amount": {
            "N": "12"
          },
          "price": {
            "N": "10"
          }
        }
      },
      "gummies": {
        "M": {
          "amount": {
            "N": "10"
          },
          "price": {
            "N": "10"
          }
        }
      },
      "ice_cream": {
        "M": {
          "amount": {
            "N": "10"
          },
          "price": {
            "N": "10"
          }
        }
      },
      "instant_cup_noodle": {
        "M": {
          "amount": {
            "N": "10"
          },
          "price": {
            "N": "10"
          }
        }
      },
      "nuts": {
        "M": {
          "amount": {
            "N": "10"
          },
          "price": {
            "N": "10"
          }
        }
      },
      "orange_juice": {
        "M": {
          "amount": {
            "N": "10"
          },
          "price": {
            "N": "10"
          }
        }
      },
      "salads": {
        "M": {
          "amount": {
            "N": "10"
          },
          "price": {
            "N": "10"
          }
        }
      },
      "sandwiches": {
        "M": {
          "amount": {
            "N": "10"
          },
          "price": {
            "N": "10"
          }
        }
      },
      "soda": {
        "M": {
          "amount": {
            "N": "10"
          },
          "price": {
            "N": "10"
          }
        }
      },
      "sweet_candy": {
        "M": {
          "amount": {
            "N": "10"
          },
          "price": {
            "N": "10"
          }
        }
      },
      "tea": {
        "M": {
          "amount": {
            "N": "10"
          },
          "price": {
            "N": "10"
          }
        }
      },
      "water": {
        "M": {
          "amount": {
            "N": "10"
          },
          "price": {
            "N": "10"
          }
        }
      }
    }
  }
}

ITEM
}
# Init 1 EC2 instance for deploy web app
resource "aws_instance" "vending_machine_management" {
  ami           = "ami-0dfa284c9d7b2adad"
  instance_type = "t2.micro"

  iam_instance_profile = aws_iam_instance_profile.ec2_dynamodb.name
  security_groups      = [aws_security_group.allow_streamlit.name]
  tags = {
    Name = "tf_vending_machine_management"
  }
}
# Init IAM role for EC2 to get/write to dynamodb
data "aws_iam_policy_document" "instance_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "ec2_dynamodb" {
  name               = "tf_ec2_dynamodb_vmm"
  assume_role_policy = data.aws_iam_policy_document.instance_assume_role_policy.json

  inline_policy {
    name = "read_write_dynamodb_table_tf_menu_database"

    policy = jsonencode({
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Sid" : "Stmt1703145729575",
          "Action" : [
            "dynamodb:GetItem",
            "dynamodb:UpdateItem"
          ],
          "Effect" : "Allow",
          "Resource" : "${aws_dynamodb_table.menu_database.arn}"
        }
      ]
    })
  }
}
# Init IAM instance profile with role to get/write data from DynamoDB
resource "aws_iam_instance_profile" "ec2_dynamodb" {
  name = "tf_ec2_dynamodb"
  role = aws_iam_role.ec2_dynamodb.name
}
# Init Security group to allow access from outside to port 8501
resource "aws_security_group" "allow_streamlit" {
  name        = "sg_allow_streamlit_http"
  description = "Allow streamlit inbound traffic"
}
resource "aws_security_group_rule" "outbound_all" {
  type              = "egress"
  to_port           = 0
  protocol          = "-1"
  from_port         = 0
  cidr_blocks       = ["0.0.0.0/0"]
  ipv6_cidr_blocks  = ["::/0"]
  security_group_id = aws_security_group.allow_streamlit.id
}
resource "aws_security_group_rule" "inbound_8501" {
  type                     = "ingress"
  to_port                  = 8501
  protocol                 = "tcp"
  from_port                = 8501
  source_security_group_id = aws_security_group.sg_alb.id
  security_group_id        = aws_security_group.allow_streamlit.id
}
resource "aws_security_group_rule" "inbound_22" {
  type              = "ingress"
  to_port           = 22
  protocol          = "tcp"
  from_port         = 22
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.allow_streamlit.id
}
# Init 1 app load balancer for secure http and connect to EC2
resource "aws_lb" "alb_vmm" {
  name               = "alb-vmm"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.sg_alb.id]
  subnets            = data.aws_subnets.default_vpc_subnet.ids
}
data "aws_subnet" "vmm_subnet" {
  id = aws_instance.vending_machine_management.subnet_id
}
data "aws_subnets" "default_vpc_subnet" {
  filter {
    name   = "vpc-id"
    values = [data.aws_subnet.vmm_subnet.vpc_id]
  }
}
resource "aws_lb_target_group" "alb_vmm" {
  name     = "alb-vmm-tg"
  port     = 8501
  protocol = "HTTP"
  vpc_id   = data.aws_subnet.vmm_subnet.vpc_id

  lifecycle {
    create_before_destroy = true
  }
}
resource "aws_lb_target_group_attachment" "alb_vmm" {
  target_group_arn = aws_lb_target_group.alb_vmm.arn
  target_id        = aws_instance.vending_machine_management.id
  port             = 8501
}
# resource "aws_lb_listener" "alb_vmm" {
#   load_balancer_arn = aws_lb.alb_vmm.arn
#   port              = 80
#   protocol          = "HTTP"

#   default_action {
#     type             = "forward"
#     target_group_arn = aws_lb_target_group.alb_vmm.arn
#   }
# }
resource "aws_lb_listener" "alb_vmm" {
  load_balancer_arn = aws_lb.alb_vmm.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = aws_acm_certificate_validation.cert_validation.certificate_arn
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb_vmm.arn
  }
}
# Init security group to allow access from outside to port 80
resource "aws_security_group" "sg_alb" {
  name        = "sg_alb_http"
  description = "Allow alb inbound traffic"
}
resource "aws_security_group_rule" "alb_outbound_all" {
  type              = "egress"
  to_port           = 0
  protocol          = "-1"
  from_port         = 0
  cidr_blocks       = ["0.0.0.0/0"]
  ipv6_cidr_blocks  = ["::/0"]
  security_group_id = aws_security_group.sg_alb.id
}
# resource "aws_security_group_rule" "inbound_80" {
#   type              = "ingress"
#   to_port           = 80
#   protocol          = "tcp"
#   from_port         = 80
#   cidr_blocks       = ["0.0.0.0/0"]
#   security_group_id = aws_security_group.sg_alb.id
# }
resource "aws_security_group_rule" "inbound_443" {
  type              = "ingress"
  to_port           = 443
  protocol          = "tcp"
  from_port         = 443
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.sg_alb.id
}
# Init forwarding route from alb to route53 for custom domain
data "aws_route53_zone" "custom_domain" {
  name = "datlamdevops.tech."
}
resource "aws_route53_record" "tfvmm" {
  zone_id = data.aws_route53_zone.custom_domain.zone_id
  name    = "vmm.${data.aws_route53_zone.custom_domain.name}"
  type    = "A"

  alias {
    name                   = aws_lb.alb_vmm.dns_name
    zone_id                = aws_lb.alb_vmm.zone_id
    evaluate_target_health = true
  }
}

# Request SSL certificate for custom domain
resource "aws_acm_certificate" "cert" {
  domain_name       = aws_route53_record.tfvmm.name
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}
resource "aws_route53_record" "cert_validation" {
  for_each = {
    for dvo in aws_acm_certificate.cert.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = data.aws_route53_zone.custom_domain.zone_id
}

resource "aws_acm_certificate_validation" "cert_validation" {
  certificate_arn         = aws_acm_certificate.cert.arn
  validation_record_fqdns = [for record in aws_route53_record.cert_validation : record.fqdn]
}
