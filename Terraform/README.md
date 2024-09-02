# shd-entra

This repository contains the projects for Microsoft Entra.

## Table of Contents
- [Introduction](#introduction)
- [Projects](#projects)
  - [PIM Group Onboarding for AWS into Entra](#pim_onboarding_for_aws_into_entra)
  - [PIM Group Onboarding for Entra Roles](#pim_onboarding_for_aws_entra_roles)

## Introduction

Repository for all things Entra.

## Projects

### PIM Group Onboarding for AWS into Entra

This project provides the necessary Terraform code to onboard PIM groups for AWS into Entra, enabling centralized management and control over privileged access.

1. Download the `pim_aws_groups.csv` file.
2. Add additional rows for each PIM group that needs to be created.
3. Upload the modified `pim_aws_groups.csv` file.
4. Pull and merge to deploy to Entra.

Rows should be formatted as such for `pim_aws_groups.csv`
|local_id|pim_group                |ad_group             |ticketInfo |justification                          |maximum_duration|require_approval|approval_group       |assignmentType|
|--------|-------------------------|---------------------|-----------|---------------------------------------|----------------|----------------|---------------------|--------------|
|1       |group_pim                |ad_group             |RITM0000000|"Entra ID PIM AWS Onboarding PBI000000"|PT8H            |true            |approval_group       |eligible      |

Fields description

- `local_id` - The local ID that Terraform uses to keep track of the groups. Before uploading, make sure to order the CSV by this column.
- `pim_group` - The display name of the PIM group.
- `ad_group` - The display name of the AD group.
- `ticketInfo` - ServiceNow RITM.
- `justification` - A brief description of why the group is being brought into PIM management. For audit purposes.
- `maximum_duration` - The maximum length of time an activated role can be valid, in an `ISO8601` Duration format (e.g. PT8H). The valid range is `PT30M` to `PT23H30M`, in 30-minute increments, or PT1D.
- `require_approval` - Indicates whether approval is required for activation. Must be lowercase.
- `approval_group` - The display name of the approval group.
- `assignmentType` - Indicates whether the assignment is active or eligible. Must be lowercase.
---

### PIM Group Onboarding for Entra Roles
This project provides the necessary Terraform code to onboard PIM groups for Entra roles, enabling centralized management and control over privileged access.

1. Download the `pim_entra_roles.csv` file.
2. Add additional rows for each PIM group that needs to be created.
3. Upload the modified `pim_entra_roles.csv` file.
4. Pull and merge to deploy to Entra.

Rows should be formatted as such for `pim_entra_roles.csv`
|local_id|pim_group              |ad_group           |ticketInfo |justification               |maximum_duration|require_approval|approval_group|assignmentType|
|--------|-----------------------|-------------------|-----------|----------------------------|----------------|----------------|--------------|--------------|
|1       |entra_role_group_pim   |ad_group           |RITM0000000|"PIM Entra Roles, PBI000000"|PT8H            |true            |approval_group|eligible      |

Fields description

- `local_id` - The local ID that Terraform uses to keep track of the groups. Before uploading, make sure to order the CSV by this column.
- `pim_group` - The display name of the PIM group.
- `ad_group` - The display name of the AD group.
- `ticketInfo` - ServiceNow RITM.
- `justification` - A brief description of why the group is being brought into PIM management. For audit purposes.
- `maximum_duration` - The maximum length of time an activated role can be valid, in an `ISO8601` Duration format (e.g. PT8H). The valid range is `PT30M` to `PT23H30M`, in 30-minute increments, or PT1D.
- `require_approval` - Indicates whether approval is required for activation. Must be lowercase.
- `approval_group` - The display name of the approval group.
- `assignmentType` - Indicates whether the assignment is active or eligible. Must be lowercase.
---