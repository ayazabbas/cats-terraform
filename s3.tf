resource "aws_s3_bucket" "streetbees_deployment_bucket" {
  bucket = "streetbees-deployment-bucket-${data.aws_caller_identity.current.account_id}"
}

resource "aws_s3_bucket_object" "streetbees_cats_archive" {
  key    = "cats/cats-${var.app_version}.zip"
  bucket = aws_s3_bucket.streetbees_deployment_bucket.id
  source = "tmp/cats.zip"
}
