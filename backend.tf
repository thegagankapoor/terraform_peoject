terraform {
  backend "s3" {
    bucket         = "my-unique-terraform-project-bucket-2025-05-10"
    key            = "terraform/statefile/terraform.tfstate"
    region         = "ap-south-1"
  }
}