data "azuread_client_config" "current" {}

data "azuread_group" "approval_group" {
  display_name     = var.approval_group
  security_enabled = true
}

data "azuread_group" "ad_group" {
  display_name     = var.ad_group
  security_enabled = true
}

data "azuread_group" "pim_group" {
  display_name     = var.pim_group
  security_enabled = true
}