

resource "alicloud_security_group" "basiton" {
  name        = "basiton"
  description = "basiton security group"
  vpc_id = alicloud_vpc.vpc.id
}

resource "alicloud_security_group_rule" "allow_ssh-basiton" {
  type              = "ingress"
  ip_protocol       = "tcp"
  policy            = "accept"
  port_range        = "22/22"
  priority          = 1
  security_group_id = alicloud_security_group.basiton.id
  cidr_ip           = "0.0.0.0/0"
}