terraform {
    required_providers {
        aws = {
        source  = "hashicorp/aws"
        version = "~> 3.0"
        }
        atlas = {
          source = "ariga/atlas"
          version = "~> 0.4.5"
        }
    }
}

provider "aws" {
  region  = "us-east-1"
}

data "aws_vpc" "default" {
  default = true
}

resource "random_string" "this" {
  length  = 32
  upper   = true
  special = false
}

resource "aws_security_group" "this" {
  vpc_id      = "${data.aws_vpc.default.id}"
  name        = "postgres-sg"
  description = "Allow all inbound for Postgres"
  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_db_instance" "this" {
  identifier             = "postgres-demo"
  instance_class         = "db.t3.micro"
  allocated_storage      = 5
  engine                 = "postgres"
  engine_version         = "15.5"
  skip_final_snapshot    = true
  publicly_accessible    = true
  vpc_security_group_ids = [aws_security_group.this.id]
  username               = "dummy"
  password               = random_string.this.result
}

data "atlas_schema" "schema" {
  dev_url = "postgres://dummy:${random_string.this.result}@${aws_db_instance.this.address}:5432/postgres"
  src     = file("${path.module}/schema.hcl")
  depends_on = [aws_db_instance.this]
}

resource "atlas_schema" "schema" {
  hcl = data.atlas_schema.schema.hcl
  url = "postgres://dummy:${random_string.this.result}@${aws_db_instance.this.address}:5432/postgres"
  depends_on = [aws_db_instance.this]
}

