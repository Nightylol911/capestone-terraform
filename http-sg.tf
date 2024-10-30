

resource "alicloud_security_group" "http" {
  name        = "http"
  description = "http security group"
  vpc_id = alicloud_vpc.vpc.id
}

resource "alicloud_security_group_rule" "allow-web-ssh" {
  type              = "ingress"
  ip_protocol       = "tcp"
  policy            = "accept"
  port_range        = "22/22"
  priority          = 1
  security_group_id = alicloud_security_group.http.id
  source_security_group_id = alicloud_security_group.basiton.id
}

resource "alicloud_security_group_rule" "allow_for_http" {
  type              = "ingress"
  ip_protocol       = "tcp"
  policy            = "accept"
  port_range        = "80/80"
  priority          = 1
  security_group_id = alicloud_security_group.http.id
  # source_security_group_id = alicloud_security_group.basiton.id
  cidr_ip           = "0.0.0.0/0"
}