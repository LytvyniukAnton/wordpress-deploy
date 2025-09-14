locals {
  allowed_ips_list = (
    can(regex(",", join("", var.allowed_ips))) ?
    split(",", join("", var.allowed_ips)) :
    var.allowed_ips
  )
}
