# Update Ansible inventory
resource "local_file" "ansible_host" {
  depends_on = [aws_instance.k8s_master]
  content    = "[Master_Node]\n${aws_instance.k8s_master.public_ip}\n\n[Worker_Node]\n${aws_instance.k8s_worker.public_ip}"
  filename   = "inventory"
}

# Run Ansible playbook 
resource "null_resource" "null1" {
  depends_on = [
    local_file.ansible_host
  ]
  provisioner "local-exec" {
    command = "sleep 10"
  }
  provisioner "local-exec" {
    command = "ansible-playbook ansible-playbook.yml"
  }
}
# Print K8s Master and Worker node IP
output "Master_Node_IP" {
  value = aws_instance.k8s_master.public_ip
}
