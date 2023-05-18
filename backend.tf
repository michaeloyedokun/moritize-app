terraform {
  backend "s3" {
    bucket         = "terraform-state-bucket-malchiel"
    key            = "terraform-aws-eks-workshop.tfstate"
    region         = "eu-west-1"
    encrypt        = true
    dynamodb_table = "terraform-s3-backend-malchiel"
  }
}