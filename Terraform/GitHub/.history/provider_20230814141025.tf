provider "github" {
  token = var.token
}

resource "github_repository" "example_repo" {
  name        = "my-terraform-repo"
  description = "Example repository created using Terraform"
  visibility  = "public"
}






