output "instance_id" {
  value = aws_instance.HELK.id
}

output "SSH_address" {
  value = aws_instance.HELK.public_ip
}
output "ssh_connection_string" {
  value = "ssh -i ${var.aws_pem} ubuntu@${aws_instance.HELK.public_ip}"
}