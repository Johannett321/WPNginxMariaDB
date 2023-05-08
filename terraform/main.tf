resource "openstack_compute_instance_v2" "Worker-test_instance" {
  name = "Worker-test"
  flavor_name = "b2.c2r4"
  key_pair = "Master V2"
  network {
    name = "public"
  }
  block_device {
    uuid = "aac74808-9dba-4f49-a530-70a23b4163f3"
    source_type = "image"
    volume_size = 30
    boot_index = 0
    destination_type = "volume"
    delete_on_termination = true
  }
  connection {
    type = "ssh"
    user = "ubuntu"
    private_key = "${file("~/.ssh/id_rsa")}"
    host = openstack_compute_instance_v2.Worker-test_instance.access_ip_v4
  }
  provisioner "file" {
    source      = "/home/ubuntu/Terraform/puppetins.sh"
    destination = "/tmp/puppetins.sh"
  }
  provisioner "file" {
    source      = "/home/ubuntu/Terraform/install_kube.sh"
    destination = "/tmp/install_kube.sh"
  }
  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/puppetins.sh",
      "echo 'starting script'",
      "sudo /tmp/puppetins.sh",
      "echo 'starting kubernetes installer...' && sleep 3",
      "chmod a+x /tmp/install_kube.sh",
      "sudo /tmp/install_kube.sh",
      "echo 'Script Finito'",
    ]
  }
}
