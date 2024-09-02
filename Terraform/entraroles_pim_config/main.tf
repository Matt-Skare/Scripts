# Create a privileged role assignment

resource "azuread_privileged_access_group_assignment_schedule" "active_entra" {
  count  = var.assignmentType == "active" ? 1 : 0
  group_id             = data.azuread_group.pim_group.object_id
  principal_id         = data.azuread_group.ad_group.object_id
  assignment_type      = "member"
  justification        = var.justification
  ticket_number        = var.ticket_number
  ticket_system        = "sNOW"
  permanent_assignment = true
}

resource "azuread_privileged_access_group_eligibility_schedule" "eligible_entra" {
  count  = var.assignmentType == "eligible" ? 1 : 0
  group_id             = data.azuread_group.pim_group.object_id
  principal_id         = data.azuread_group.ad_group.object_id
  assignment_type      = "member"
  justification        = var.justification
  ticket_number        = var.ticket_number
  ticket_system        = "sNOW"
  permanent_assignment = true
}

resource "azuread_group_role_management_policy" "pim_policy" {
  group_id   = data.azuread_group.pim_group.object_id
  role_id    = "member"
  activation_rules{
    approval_stage{
      primary_approver{
        object_id = data.azuread_group.approval_group.object_id
        type = "groupMembers"
      }
    }
    maximum_duration = var.maximum_duration
    require_approval = var.require_approval
    # require_justification = false
    require_multifactor_authentication = true
    require_ticket_info = true
    # required_conditional_access_authentication_context
  }
  active_assignment_rules{
    expiration_required = false
    # expire_after = P365D
    require_justification = true
    require_multifactor_authentication = false
    require_ticket_info = true
  }
  eligible_assignment_rules{
    expiration_required = false
    #expire_after = P365D
  }
  # notification_rules{
  #   active_assignments{
  #     admin_notifications{
  #       notification_settings{
  #         default_recipients = 
  #       }
  #     }
  #   }
  # }
}