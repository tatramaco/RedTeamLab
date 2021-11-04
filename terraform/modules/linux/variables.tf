variable "alt_ssh_source_ip" {
  description = "An additional IP address from which to SSH"

}

variable "ssh_key" {
  description = "The AWS Key Pair to use for SSH"
}

variable "aws_pem" {
  description = "The PEM file to use for SSH. This is outputted with the IP for convenience"
}

variable "vpcid" {
  description = "AWS VPC id"
}
variable "lab-subnet" {
  description = "AWS VPC subnet"
}