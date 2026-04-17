provider "aws" {
  region = "us-east-1"
}

# ❌ 1. S3 Bucket with Public Policy (Explicit Public Read)
resource "aws_s3_bucket" "bad_bucket" {
  bucket = "codeant-demo-bad-bucket-67890"
}

resource "aws_s3_bucket_policy" "public_policy" {
  bucket = aws_s3_bucket.bad_bucket.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "PublicRead",
      "Effect": "Allow",
      "Principal": "*",
      "Action": "s3:GetObject",
      "Resource": "${aws_s3_bucket.bad_bucket.arn}/*"
    }
  ]
}
EOF
}

# ❌ 2. EC2 Instance with Public IP + No Restrictions
resource "aws_instance" "insecure_ec2" {
  ami           = "ami-0c02fb55956c7d316"  # Amazon Linux
  instance_type = "t2.micro"

  associate_public_ip_address = true

  tags = {
    Name = "InsecureInstance"
  }
}

# ❌ 3. IAM Policy with Full Admin Access
resource "aws_iam_policy" "admin_policy" {
  name        = "full-admin-policy"
  description = "Overly permissive policy"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "*",
      "Resource": "*"
    }
  ]
}
EOF
}

# ❌ 4. Hardcoded AWS Credentials (BIG trigger)
locals {
  aws_access_key = "AKIA123456789EXAMPLE"
  aws_secret_key = "abcd1234secretkeyexample"
}

# ❌ 5. EBS Volume without Encryption
resource "aws_ebs_volume" "unencrypted_volume" {
  availability_zone = "us-east-1a"
  size              = 10

  encrypted = false
}
