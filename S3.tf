#s3 bucket
resource "aws_s3_bucket" "proj-s3" {
  bucket = "proj-s3-by-shamim"

  tags = {
    Name = "proj-s3"
  }
}
