module "components" {
  source = "../module/tf-module-infra"
  for_each = var.components
  zone_id = var.zone_id
  project = var.project
  security_group = var.security_group
  name = each.value["name"]
  instance_type = each.value["instance_type"]
}

