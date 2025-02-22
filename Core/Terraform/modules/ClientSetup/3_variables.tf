# MAIN VARIABLES
variable "appRegistrationName" {
  type        = string
  sensitive   = true
  description = "Name of the app registration (i.e. service principal name)."
  }