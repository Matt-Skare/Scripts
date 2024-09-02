data "azuread_client_config" "current" {}

locals {
  aws_pim_assignments = csvdecode(file("modules/aws_pim_config/pim_aws_groups.csv"))
  entraroles_pim_assignments = csvdecode(file("modules/entraroles_pim_config/pim_entra_roles.csv"))
}

module "aws_pim_config" {
  source = "./modules/aws_pim_config"
  for_each = tomap({ for inst in local.aws_pim_assignments : inst.local_id => inst })

  assignmentType       = each.value.assignmentType
  pim_group            = each.value.pim_group
  ad_group             = each.value.ad_group
  justification        = each.value.justification
  ticket_number        = each.value.ticketInfo
  approval_group       = each.value.approval_group
  maximum_duration     = each.value.maximum_duration
  require_approval     = each.value.require_approval
}

module "entraroles_pim_config" {
  source = "./modules/entraroles_pim_config"
  for_each = tomap({ for inst in local.entraroles_pim_assignments : inst.local_id => inst })

  assignmentType       = each.value.assignmentType
  pim_group            = each.value.pim_group
  ad_group             = each.value.ad_group
  justification        = each.value.justification
  ticket_number        = each.value.ticketInfo
  approval_group       = each.value.approval_group
  maximum_duration     = each.value.maximum_duration
  require_approval     = each.value.require_approval
}