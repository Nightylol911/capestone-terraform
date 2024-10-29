resource "alicloud_security_group" "redis-sg" {
  name        = "http-redis"
  description = "redis security group"
  vpc_id = alicloud_vpc.vpc.id
}

resource "alicloud_security_group_rule" "allow-ssh-reddis" {
  type              = "ingress"
  ip_protocol       = "tcp"
  policy            = "accept"
  port_range        = "22/22"
  priority          = 1
  security_group_id = alicloud_security_group.redis-sg.id
  source_security_group_id = alicloud_security_group.basiton.id
}

resource "alicloud_security_group_rule" "allow-web-reddis" {
  type              = "ingress"
  ip_protocol       = "tcp"
  policy            = "accept"
  port_range        = "6379/6379"
  priority          = 1
  security_group_id = alicloud_security_group.redis-sg.id
  source_security_group_id = alicloud_security_group.http.id
}

# check last line