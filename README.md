# RedTeamLab

A dirty automated deployment on AWS for an Active Directory Lab comprising a DC, member server and workstation along with a HELK threat hunting linux machine.

The AD will be empty but you can populate it with the provided script or https://github.com/davidprowe/BadBlood

You will need to create a ssh key for your AWS user and place it in the repo called RT_lab.pem. Ensure your user has appropriate programmatic access.

You should adjust the terraform.tfvars to set the alternative rdp source IP address and initial windows username and password.

Your AWS creds can be in a file but you are probably better setting them as environment variables.

Run the standard terraform init->plan-apply 
This will populate the IP addresses for your hosts in the ansible inventory.
Subsequently run 

ansible-playbook -i hosts playbooks/lab_build.yml 

from the ansible folder.

If you hit issues building the DC it is usually because of an issue pulling down the lab files from the URL specified in the active-directory terrafom module provisioner. You can re-run it or download manually.
