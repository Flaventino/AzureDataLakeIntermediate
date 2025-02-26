import subprocess
from pathlib import Path
from collections import namedtuple

# HELPER FUNCTIONS
def get_terraform_paths():
    """
    Returns a tuple with paths to the Terraform base folder and a bash script.

    This function takes no arguments.

    The returned tuple contains:
    - The Terraform base folder path.
    - The path to the bash script that loads and exports environment variables.

    Example usage:
    paths = get_terraform_paths()
    print(paths.tfbase)     # Path to the Terraform base folder
    print(paths.envfile)    # Path to the environment variable script
    """

    # INITIALIZATION & BASIC 
    paths = namedtuple('paths', ['tfbase', 'envfile'])

    # PATH COMPUTATIONS
    base = Path(__file__).resolve().parent.parent
    environment = base.parent / 'Credentials' / 'set_azure_env.sh'

    # FUNCTION OUTPUT
    return paths(tfbase=base, envfile=environment)


# TERRAFORM MANAGEMENT FUNCTIONS
def provision():
    """
    Deploys the Azure infrastructure for this project.

    - See README.md and the "Terraform" folder for infrastructure details.
    - This function takes no arguments and returns nothing (None).
    - At last, this function performs the following steps:
        1. Runs Terraform initialization in the correct directory.
        2. Loads environment variables required for the deployment.
        3. Applies the Terraform configuration to provision resources in Azure.
    """

    # INITIALIZATION & BASIC SETTINGS
    paths = get_terraform_paths()               # Gets terraform required paths
    terraform_dir = paths.tfbase                # Gets Terraform directory path
    env_vars_file = paths.envfile               # Gets path to env vars script

    # TERRAFORM INITIALIZATION
    kwargs = dict(cwd=terraform_dir, shell=True)
    init_process = subprocess.run(f'terraform init', **kwargs)
    
    # COMPARING DEPLOYED VS. TERRAFORM-DEFINED INFRASTRUCTURE
    base_cmd = f'source {env_vars_file} --silent && terraform plan'
    plan_test_cmd = f"{base_cmd} -no-color -detailed-exitcode > /dev/null"
    deviation_code = subprocess.run(plan_test_cmd, **kwargs).returncode

    # CONDITIONAL INFRASTRUCTURE PROVISIONING
    if deviation_code == 0:
        print(f"\nNo changes to deploy, everything is up to date.")
    elif deviation_code == 1:
        raise RuntimeError("Error encountered while running Terraform plan!")
    else:
        prov_cmd = f'source {env_vars_file} && terraform apply --auto-approve'
        provisioning_process = subprocess.run(prov_cmd, **kwargs)


def destroy():
    """
    Delete the Azure infrastructure deployed for this project.

    - See README.md and the "Terraform" folder for infrastructure details.
    - This function takes no arguments and returns nothing.
    """

    # INITIALIZATION & BASIC SETTINGS
    paths = get_terraform_paths()               # Gets terraform required paths
    terraform_dir = paths.tfbase                # Gets Terraform directory path
    env_vars_file = paths.envfile               # Gets path to env vars script
    
    # INFRASTRUCTURE DELETION
    del_cmd = f'source {env_vars_file} && terraform destroy --auto-approve'
    deletion_process = subprocess.run(del_cmd, cwd=terraform_dir, shell=True)