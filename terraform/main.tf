variable "aws_region" {
  description = "The AWS region to deploy the resources to"
}

variable "aws_pem" {
  description = "The PEM file to use for SSH. This is outputted with the IP for convenience"
}
variable "alt_rdp_source_ip" {
  description = "An additional IP address from which to RDP"

}

variable "ssh_key" {
  description = "The AWS Key Pair to use for SSH"
}

variable "win_username" {
  description = "The admin username for the domain"
}

variable "win_password" {
  description = "The admin password for the domain"
}

provider "aws" {
  region                  = var.aws_region

}

module "network" {
  source = "./modules/network"
}


module "DC" {
  source = "./modules/active-directory"

  alt_rdp_source_ip = var.alt_rdp_source_ip
  ssh_key           = var.ssh_key
  aws_pem           = var.aws_pem
  vpcid             = module.network.vpcid
  lab-subnet        = module.network.lab-subnet
  win_password      = var.win_password

}

module "workstation1" {
  source = "./modules/Workstation"

  alt_rdp_source_ip = var.alt_rdp_source_ip
  ssh_key           = var.ssh_key
  aws_pem           = var.aws_pem
  vpcid             = module.network.vpcid
  lab-subnet        = module.network.lab-subnet
  win_password      = var.win_password

}

module "member-server" {
  source = "./modules/member-server"

  alt_rdp_source_ip = var.alt_rdp_source_ip
  ssh_key           = var.ssh_key
  aws_pem           = var.aws_pem
  vpcid             = module.network.vpcid
  lab-subnet        = module.network.lab-subnet
  win_password      = var.win_password

}

module "HELK" {
  source = "./modules/linux"

  alt_ssh_source_ip = var.alt_rdp_source_ip
  ssh_key           = var.ssh_key
  aws_pem           = var.aws_pem
  vpcid             = module.network.vpcid
  lab-subnet        = module.network.lab-subnet
}