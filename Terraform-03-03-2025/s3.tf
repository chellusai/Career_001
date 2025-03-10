resource "aws_s3_bucket" "career1" {
  bucket = "red-chicken"

  tags = {
    Name        = "career1"
  }
  depends_on = [ aws_security_group.allow_all ]
}

resource "aws_s3_bucket" "career2" {
  bucket = "greem-chicken"

  tags = {
    Name        = "career2"
  }
  depends_on = [ aws_s3_bucket.career1 ]
}

resource "aws_s3_bucket" "career3" {
  bucket = "yello-chicken"

  tags = {
    Name        = "career3"
  }
  depends_on = [ aws_s3_bucket.career2 ]
}
