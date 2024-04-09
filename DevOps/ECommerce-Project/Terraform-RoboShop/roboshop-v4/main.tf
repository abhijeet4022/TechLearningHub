module "components" {
  source = "git::https://github.com/abhijeet4022/TechLearningHub/tree/main/DevOps/ECommerce-Project/Terraform-RoboShop/roboshop-v3/module"
  for_each = var.components
  zone_id = var.zone_id
  project = var.project
  security_group = var.security_group
  name = each.value["name"]
  instance_type = each.value["instance_type"]
}

