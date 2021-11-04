output "instance_id" {
  value = aws_instance.member-server.id
}

output "RDP_address" {
  value = aws_instance.member-server.public_ip
}

output "RDP_UserName" {
  value = "Administrator"
}

output "RDP_Password" {     value = rsadecrypt(aws_instance.member-server.password_data, file(var.aws_pem)) }
