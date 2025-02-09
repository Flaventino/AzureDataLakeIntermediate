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
# variable "projectDatalakeContainerName" {
#   type        = string
#   sensitive   = true
#   description = "Name of the storage container within the project's data lake."
#   }
# variable "projectFlatFilesDirectoryName" {
#   type        = string
#   sensitive   = true
#   description = "Name of the directory within the storage container for flat files."
#   }
# variable "projectParquetFilesDirectoryName" {
#   type        = string
#   sensitive   = true
#   description = "Name of the directory within the storage container for parquet files."
#   }