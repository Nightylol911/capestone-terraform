
# Create a new ECS instance for VPC
resource "alicloud_vpc" "vpc" {
  vpc_name   = "capstone_vpc"
  cidr_block = "10.0.0.0/8"
}

resource "alicloud_vswitch" "public-a" {
  vswitch_name = "public-a"
  vpc_id     = alicloud_vpc.vpc.id
  cidr_block = "10.0.1.0/24"
  zone_id    = data.alicloud_zones.default.zones.0.id
}

resource "alicloud_vswitch" "public-b" {
  vswitch_name = "public-b"
  vpc_id     = alicloud_vpc.vpc.id
  cidr_block = "10.0.4.0/24"
  zone_id    = data.alicloud_zones.default.zones.1.id
}

resource "alicloud_vswitch" "private" {
  vswitch_name = "private"
  vpc_id      = alicloud_vpc.vpc.id
  cidr_block = "10.0.2.0/24"
  zone_id = data.alicloud_zones.default.zones.0.id
}

resource "alicloud_nat_gateway" "nat" {
  vpc_id           = alicloud_vpc.vpc.id
  nat_gateway_name = "myNat"
  payment_type     = "PayAsYouGo"
  vswitch_id       = alicloud_vswitch.public-a.id
  nat_type         = "Enhanced"
}

resource "alicloud_eip_address" "nat_eip" {
  description               = "nat elastic IP address"
  address_name              = "nat_eip"
  netmode                   = "public"
  bandwidth                 = "100"
  payment_type              = "PayAsYouGo"
  internet_charge_type       = "PayByTraffic"
}

resource "alicloud_eip_association" "example" {
  allocation_id = alicloud_eip_address.nat_eip.id
  instance_id   = alicloud_nat_gateway.nat.id
  instance_type = "Nat"
}

resource "alicloud_snat_entry" "default" {
  snat_table_id     = alicloud_nat_gateway.nat.snat_table_ids
  source_vswitch_id = alicloud_vswitch.private.id
  snat_ip           = alicloud_eip_address.nat_eip.ip_address
}

resource "alicloud_route_table" "private" {
  description      = "private route table"
  vpc_id           = alicloud_vpc.vpc.id
  # name should be "private" on the route table name
  route_table_name = "nat-route-table"
  associate_type   = "VSwitch"
}

resource "alicloud_route_entry" "nat_entry" {
  route_table_id        = alicloud_route_table.private.id
  destination_cidrblock = "0.0.0.0/0"
  nexthop_type          = "NatGateway"
  nexthop_id            = alicloud_nat_gateway.nat.id
}

resource "alicloud_route_table_attachment" "foo" {
  vswitch_id     = alicloud_vswitch.private.id
  route_table_id = alicloud_route_table.private.id
}