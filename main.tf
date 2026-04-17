provider "aws" {
  region = "us-east-1"
}

# ❌ 1. Public S3 Bucket (No blocking, no encryption)
resource "aws_s3_bucket" "public_bucket" {
  bucket = "codeant-demo-public-bucket-12345"
}

resource "aws_s3_bucket_public_access_block" "public_access" {
  bucket = aws_s3_bucket.public_bucket.id

  block_public_acls   = false
  block_public_policy = false
  ignore_public_acls  = false
  restrict_public_buckets = false
}

# ❌ 2. Open Security Group (0.0.0.0/0)
resource "aws_security_group" "open_sg" {
  name        = "open-security-group"
  description = "Allow all inbound traffic"

  ingress {
    description = "Allow ALL inbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]  # 🚨 CRITICAL
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# ❌ 3. Unencrypted RDS Instance
resource "aws_db_instance" "insecure_db" {
  identifier         = "codeant-demo-db"
  engine             = "mysql"
  instance_class     = "db.t3.micro"
  allocated_storage  = 20

  username = "admin"
  password = "Password123!"   # 🚨 hardcoded secret

  skip_final_snapshot = true

  storage_encrypted = false   # 🚨 NO ENCRYPTION
  publicly_accessible = true  # 🚨 PUBLIC ACCESS
}
#checking IAC scan test 1
