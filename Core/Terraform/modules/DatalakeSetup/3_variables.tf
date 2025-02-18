variable "projectRgName" {
  type        = string
  sensitive   = true
  description = "Defined in the root module."
  }

variable "projectResourcesLocation" {
  type        = string
  sensitive   = true
  description = "Defined in the root module."
  }

variable "projectDatalakeName" {
  type        = string
  sensitive   = true
  description = "Defined in the root module."
  }

variable "projectDatalakeContainerName" {
  type        = string
  sensitive   = true
  description = "Defined in the root module."
  }

variable "projectDirectoryNames" {
  type        = list(string)
  sensitive   = false
  description = "List of directories to create in the data lake"
  }

variable "servicePrincipalID" {
  type        = string
  sensitive   = true
  description = "Client ID of the service principal to set as datlake access monitor."
  }