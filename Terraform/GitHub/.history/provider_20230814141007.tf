provider "github" {
  token = "YOUR_GITHUB_TOKEN"
}

resource "github_repository" "example_repo" {
  name        = "my-terraform-repo"
  description = "Example repository created using Terraform"
  visibility  = "public"
}






