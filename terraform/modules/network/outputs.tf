output "vpcid" {
  value = aws_vpc.lab-vpc.id
}
output "lab-subnet" {
  value = aws_subnet.lab-subnet.id
}