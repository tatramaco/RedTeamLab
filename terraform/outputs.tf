output "Workstation1_ID" {
  description = "AWS Id of Workstation1 EC2 instance"
  value       = module.workstation1.instance_id
}
output "Workstation1_RDP_Address" {
  description = "Public IP of Workstation1"
  value       = module.workstation1.RDP_address
}
#output "Workstation1_RDP_User" {
#  description = "Username for RDP to Workstation1"
#  value       = module.workstation1.RDP_UserName
#}
#output "Workstation1_RDP_Pass" {
#  description = "Password to RDP to Workstation1"
#  value       = module.workstation1.RDP_Password
#}

output "member-server_ID" {
  description = "AWS Id of member-server EC2 instance"
  value       = module.member-server.instance_id
}
output "member-server_RDP_Address" {
  description = "Public IP of member-server"
  value       = module.member-server.RDP_address
}
#output "member-server_RDP_User" {
#  description = "Username for RDP to member-server"
#  value       = module.member-server.RDP_UserName
#}
#output "member-server_RDP_Pass" {
#  description = "Password to RDP to member-server"
#  value       = module.member-server.RDP_Password
#}

output "DC_ID" {
  description = "AWS Id of DC EC2 instance"
  value       = module.DC.instance_id
}
output "DC_RDP_Address" {
  description = "Public IP of DC"
  value       = module.DC.RDP_address
}
#output "DC_RDP_User" {
#  description = "Username for RDP to DC"
#  value       = module.DC.RDP_UserName
#}
#output "DC_RDP_Pass" {
#  description = "Password to RDP to DC"
#  value       = module.DC.RDP_Password
#}

output "HELK_ID" {
  description = "AWS Id of HELK EC2 instance"
  value       = module.HELK.instance_id
}

output "HELK_Address" {
  description = "Public IP of HELK"
  value       = module.HELK.SSH_address
}
output "HELK_Connection_String" {
  description = "SSH connection string:"
  value       = module.HELK.ssh_connection_string
}

resource "local_file" "AnsibleInventory" {
  content = templatefile("../ansible/hosts.default",
    {
      DC_ip     = module.DC.RDP_address,
      member_ip = module.member-server.RDP_address,
      work_ip   = module.workstation1.RDP_address

    }
  )
  filename = "../ansible/hosts"
}