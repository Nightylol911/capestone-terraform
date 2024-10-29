resource "alicloud_instance" "basiton" {
  availability_zone = data.alicloud_zones.default.zones.0.id
  security_groups   = [alicloud_security_group.basiton.id]

  # series III
  instance_type              = "ecs.g6.large"
  system_disk_category       = "cloud_essd"
  system_disk_size           = 40
  image_id                   = "ubuntu_24_04_x64_20G_alibase_20240812.vhd"
  instance_name              = "http"
  vswitch_id                 = alicloud_vswitch.public-a.id
  internet_max_bandwidth_out = 10
  internet_charge_type       = "PayByTraffic"
  instance_charge_type       = "PostPaid"
  key_name                   = alicloud_ecs_key_pair.myKey.key_pair_name
}

output "bastion_server_public_ip"{
    value = alicloud_instance.basiton.public_ip
}