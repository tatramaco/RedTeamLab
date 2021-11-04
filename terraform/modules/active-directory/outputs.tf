output "instance_id" {
  value = aws_instance.DC.id
}

output "RDP_address" {
  value = aws_instance.DC.public_ip
}

output "RDP_UserName" {
  value = "Administrator"
}

output "RDP_Password" {     value = rsadecrypt(aws_instance.DC.password_data, file(var.aws_pem)) }
