variable "justification" {
  description = "Justification for role assignment"
  type        = string
}

variable "ticket_number" {
  description = "Ticket number"
  type        = string
}

variable "maximum_duration" {
  description = "Maximum duration for role activation"
  type        = string
}

variable "require_approval" {
  description = "Specify whether approval is required to activate"
  type        = bool
}

variable "approval_group" {
  description = "Displayname of the approval group"
  type        = string
}

variable "assignmentType" {
  description = "PIM assignment type (Active | Eligible)"
  type        = string
}

variable "ad_group" {
  description = "Displayname of the ad group"
  type        = string
}

variable "pim_group" {
  description = "Displayname of the pim group"
  type        = string
}