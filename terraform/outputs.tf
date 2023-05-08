# Define your outputs here
output "IPv4" {
  value = openstack_compute_instance_v2.Worker-test_instance.access_ip_v4
}
