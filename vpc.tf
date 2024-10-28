
# Create a new ECS instance for VPC
resource "alicloud_vpc" "vpc" {
  vpc_name   = "lab-1"
  cidr_block = "10.0.0.0/8"
}

resource "alicloud_vswitch" "public" {
  vpc_id     = alicloud_vpc.vpc.id
  cidr_block = "10.0.3.0/24"
  zone_id    = data.alicloud_zones.default.zones.0.id
}

resource "alicloud_vswitch" "public2" {
  vpc_id     = alicloud_vpc.vpc.id
  cidr_block = "10.0.4.0/24"
  zone_id    = data.alicloud_zones.default.zones.1.id
}

resource "alicloud_vswitch" "private" {
  vpc_id      = alicloud_vpc.vpc.id
  cidr_block = "10.0.2.0/24"
  zone_id = data.alicloud_zones.default.zones.0.id
}

resource "alicloud_nat_gateway" "default" {
  vpc_id           = alicloud_vpc.vpc.id
  nat_gateway_name = "myNat"
  payment_type     = "PayAsYouGo"
  vswitch_id       = alicloud_vswitch.public.id
  nat_type         = "Enhanced"
}

resource "alicloud_eip_address" "nat" {
  description               = "nat"
  address_name              = "nat"
  netmode                   = "public"
  bandwidth                 = "100"
  payment_type              = "PayAsYouGo"
  internet_charge_type       = "PayByTraffic"
}

resource "alicloud_eip_association" "example" {
  allocation_id = alicloud_eip_address.nat.id
  instance_id   = alicloud_nat_gateway.default.id
  # add the following line (missing line)
  # instance_type = "Nat"
}

resource "alicloud_snat_entry" "default" {
  snat_table_id     = alicloud_nat_gateway.default.snat_table_ids
  source_vswitch_id = alicloud_vswitch.private.id
  snat_ip           = alicloud_eip_address.nat.ip_address
}

resource "alicloud_route_table" "private" {
  description      = "private"
  vpc_id           = alicloud_vpc.vpc.id
  # name should be "private" on the route table name
  route_table_name = var.name
  associate_type   = "VSwitch"
}

resource "alicloud_route_entry" "nat" {
  route_table_id        = alicloud_route_table.private.id
  destination_cidrblock = "0.0.0.0/0"
  nexthop_type          = "NatGateway"
  nexthop_id            = alicloud_nat_gateway.default.id
}

resource "alicloud_route_table_attachment" "foo" {
  vswitch_id     = alicloud_vswitch.private.id
  route_table_id = alicloud_route_table.private.id
}