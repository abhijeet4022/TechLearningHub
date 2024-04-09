resource "github_repository" "terraform" {
  name        = "terraform"
  description = "Repository for managing AWS Infrastructure as Code (IAC) using Terraform."
  visibility  = "public"
  auto_init = true
}