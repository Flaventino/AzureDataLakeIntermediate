#!/bin/bash

# CONTEXT & PURPOSE OF THIS SCRIPT
# This is a short Bash script designed to remove any files that Terraform
# creates automatically. The script resets the hosting directory to its
# original, "virgin" state but focuses only on terraform files.
#
# NOTICE: Use this script with caution. It is recommended to run it only after
# executing `terraform destroy` to ensure that any deployments are properly
# cleaned up.

# BODY OF THE SCRIPT
echo "TERRAFORM PROJECT RESET"
echo ">>> All automatically created files and/or directories will be deleted."

# GETS THE CURRENT LOCATION OF THE SCRIPT AS A FULL ABSOLUTE PATH
SCRIPT_DIR="$(dirname "$(realpath "${BASH_SOURCE[0]}")")" # Gets full abs. path

# DELETING DIRETORIES & FILES
rm -rf "$SCRIPT_DIR/.terraform"
rm -f  "$SCRIPT_DIR/.terraform.lock.hcl"
rm -f  "$SCRIPT_DIR/terraform.tfstate"
rm -f  "$SCRIPT_DIR/terraform.tfstate.backup"

# LEAVING MESSAGE
echo ">>> Reset done successfully!"