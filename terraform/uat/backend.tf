terraform {
  backend "s3" {
    bucket         = "jfc-tf-state-bucket"
    key            = "uat/terraform.tfstate"
    region         =  "us-west-2"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}
