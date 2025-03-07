resource "aws_s3_bucket" "ctindiawin" {
  bucket = "my-tf-test-bucket"

  tags = {
    Name        = "ctindiawin"
  }
}