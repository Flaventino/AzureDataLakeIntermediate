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

# variable "projectFlatFilesDirectoryName" {
#   type        = string
#   sensitive   = true
#   description = "Defined in the root module."
#   }

# variable "projectParquetFilesDirectoryName" {
#   type        = string
#   sensitive   = true
#   description = "Defined in the root module."
#   }
variable "projectDirectoryNames" {
  type        = list(string)
  sensitive   = false
  description = "List of directories to create in the data lake"
  }