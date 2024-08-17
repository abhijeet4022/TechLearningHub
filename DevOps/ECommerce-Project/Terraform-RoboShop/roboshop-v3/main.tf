module "components" {
  for_each = var.components

  source         = "./module"
  zone_id        = var.zone_id
  security_group = var.security_group
  project        = var.project
  name           = each.value["name"]
  instance_type  = each.value["instance_type"]
}