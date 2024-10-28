resource "alicloud_ecs_key_pair" "myKey" {
  key_pair_name = "myKey"
  key_file = "myKey.pem"
}