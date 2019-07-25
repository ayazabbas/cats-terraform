provider "aws" {
  region = "eu-west-1"
}

terraform {
  backend "s3" {
    bucket         = "terraform-state-storage-858463413507"
    dynamodb_table = "terraform_state_lock"
    key            = "streetbees-cats.tfstate"
    region         = "eu-west-1"

  }
}
