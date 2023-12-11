# Run Ansible playbook 
resource "null_resource" "null1" {
    depends_on = [
      local_file.ansible_host
    ]
  provisioner "local-exec" {
    command = "sleep 60"
    }
  provisioner "local-exec" {
    command = "ansible-playbook ansible-playbook.yml"
    }
}
# Print K8s Master and Worker node IP
output "Master_Node_IP" {
  value = aws_instance.k8s_master.public_ip
}
# output "Worker_Node_IP" {
#   value = join(", ", azurerm_linux_virtual_machine.myk8svm.*.public_ip_address)
# }