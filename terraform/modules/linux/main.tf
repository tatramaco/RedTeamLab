data "http" "myip" {
  url = "http://ipv4.icanhazip.com"
}

data "aws_availability_zones" "all" {}

data "aws_ami" "HELK" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"]
}

resource "aws_security_group" "lab-ELK-sg" {
  name   = "lab-ELK-sg"
  vpc_id = var.vpcid
}

resource "aws_security_group_rule" "sg-ELK-ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["${chomp(data.http.myip.body)}/32"]
  security_group_id = aws_security_group.lab-ELK-sg.id
}

resource "aws_security_group_rule" "sg-ELK-ssh2" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = [var.alt_ssh_source_ip]
  security_group_id = aws_security_group.lab-ELK-sg.id
}

resource "aws_security_group_rule" "sg-ELK-tls" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["${chomp(data.http.myip.body)}/32"]
  security_group_id = aws_security_group.lab-ELK-sg.id
}

resource "aws_security_group_rule" "sg-ELK-tls2" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = [var.alt_ssh_source_ip]
  security_group_id = aws_security_group.lab-ELK-sg.id
}

resource "aws_security_group_rule" "sg-ELK-internal" {
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = -1
  cidr_blocks       = ["10.0.1.0/24"]
  security_group_id = aws_security_group.lab-ELK-sg.id
}

resource "aws_security_group_rule" "allow_all" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.lab-ELK-sg.id
}

resource "aws_instance" "HELK" {
  ami                    = data.aws_ami.HELK.id
  instance_type          = "t3a.xlarge"
  key_name               = var.ssh_key
  vpc_security_group_ids = [aws_security_group.lab-ELK-sg.id]
  subnet_id              = var.lab-subnet
  private_ip            = "10.0.1.50"
  ebs_optimized = true
  root_block_device {
    volume_size = 32
  }

  user_data              = file("./modules/linux/HELK.sh")
  tags = {
    Name = "HELK"
  }
   metadata_options {
       http_endpoint = "enabled"
       http_tokens   = "required"
  }
}