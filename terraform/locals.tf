locals {
  existing_sg_id = try(data.aws_security_group.nginx[0].id, null)
}

locals {
  allowed_ips_list = (
    can(regex(",", join("", var.allowed_ips))) ?
    split(",", join("", var.allowed_ips)) :
    var.allowed_ips
  )
}
