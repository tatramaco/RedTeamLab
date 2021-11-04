output "instance_id" {
  value = aws_instance.workstation1.id
}

output "RDP_address" {
  value = aws_instance.workstation1.public_ip
}

output "RDP_UserName" {
  value = "Administrator"
}

output "RDP_Password" {     value = rsadecrypt(aws_instance.workstation1.password_data, file(var.aws_pem)) }
