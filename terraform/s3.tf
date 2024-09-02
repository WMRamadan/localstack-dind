# Create an S3 bucket
resource "aws_s3_bucket" "file_bucket" {
  bucket = "file-bucket"
}

resource "aws_s3_bucket_acl" "file_bucket_acl" {
  bucket = aws_s3_bucket.file_bucket.bucket
  acl    = "public-read" # Set the desired ACL here
}

# Upload a file to the S3 bucket
resource "aws_s3_object" "data_file" {
  bucket = aws_s3_bucket.file_bucket.bucket
  key    = "data.txt"        # File name in S3
  source = "./data/data.txt" # Local file path
  acl    = "public-read"     # Make the object publicly readable
}

# Set a bucket policy to allow public access to objects
resource "aws_s3_bucket_policy" "file_bucket_policy" {
  bucket = aws_s3_bucket.file_bucket.bucket

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "PublicReadGetObject",
        "Effect" : "Allow",
        "Principal" : "*",
        "Action" : "s3:GetObject",
        "Resource" : "arn:aws:s3:::file-bucket/*"
      }
    ]
  })
}
