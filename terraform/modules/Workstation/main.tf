data "http" "myip" {
  url = "http://ipv4.icanhazip.com"
}

data "aws_availability_zones" "all" {}

data "aws_ami" "windows" {
  most_recent = true

  filter {
    name   = "name"
    values = ["Windows_Server-2016-English-Full-Base-2021.08.11"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["amazon"]
}

resource "aws_security_group" "lab-work-sg" {
  name   = "lab-work-sg"
  vpc_id = var.vpcid
}

resource "aws_security_group_rule" "sg-work-rdp" {
  type              = "ingress"
  from_port         = 3389
  to_port           = 3389
  protocol          = "tcp"
  cidr_blocks       = ["${chomp(data.http.myip.body)}/32"]
  security_group_id = aws_security_group.lab-work-sg.id
}

resource "aws_security_group_rule" "sg-work-rdp2" {
  type              = "ingress"
  from_port         = 3389
  to_port           = 3389
  protocol          = "tcp"
  cidr_blocks       = [var.alt_rdp_source_ip]
  security_group_id = aws_security_group.lab-work-sg.id
}

resource "aws_security_group_rule" "sg-work-winrm" {
  type              = "ingress"
  from_port         = 5986
  to_port           = 5986
  protocol          = "tcp"
  cidr_blocks       = ["${chomp(data.http.myip.body)}/32"]
  security_group_id = aws_security_group.lab-work-sg.id
}

resource "aws_security_group_rule" "sg-work-winrm2" {
  type              = "ingress"
  from_port         = 5986
  to_port           = 5986
  protocol          = "tcp"
  cidr_blocks       = [var.alt_rdp_source_ip]
  security_group_id = aws_security_group.lab-work-sg.id
}

resource "aws_security_group_rule" "sg-work-internal" {
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = -1
  cidr_blocks       = ["10.0.1.0/24"]
  security_group_id = aws_security_group.lab-work-sg.id
}

resource "aws_security_group_rule" "allow_all" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.lab-work-sg.id
}

resource "aws_instance" "workstation1" {
  ami                    = data.aws_ami.windows.id
  instance_type          = "t3a.large"
  key_name               = var.ssh_key
  vpc_security_group_ids = [aws_security_group.lab-work-sg.id]
  subnet_id              = var.lab-subnet
  private_ip            = "10.0.1.30"
  get_password_data      = true
  ebs_optimized = true
  tags = {
    Name = "workstation1"
  }
     metadata_options {
       http_endpoint = "enabled"
       http_tokens   = "required"
  }
  user_data = <<EOF
<powershell>
$admin = [adsi]("WinNT://./${var.win_username}, user")
$admin.PSBase.Invoke("SetPassword", "${var.win_password}")
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
Invoke-Expression ((New-Object System.Net.Webclient).DownloadString('https://raw.githubusercontent.com/ansible/ansible/devel/examples/scripts/ConfigureRemotingForAnsible.ps1'))
</powershell>
EOF

provisioner "file" {
    source      = "./modules/Workstation/files/"
    destination = "c:/users/Administrator/Downloads"
    connection {
    type     = "winrm"
    user     = "Administrator"
    password = "${var.win_password}"
    host     = self.public_ip
    https = true
    insecure = true
  }
  }
}