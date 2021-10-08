provider "alicloud" {
  configuration_source = "terraform-provider-alicloud/examples/vpc"
}

resource "alicloud_vpc" "main" {
  # VPC名称
  name       = "alicloud"
  # VPC地址块
  cidr_block = "10.1.0.0/21"
}

resource "alicloud_vswitch" "main" {
  # VPC ID
  vpc_id            = alicloud_vpc.main.id
  # 交换机地址块
  cidr_block        = "10.1.0.0/24"
  # 可用区
  availability_zone = "cn-hangzhou-b"
  # 资源依赖,会优先创建该依赖资源
  depends_on = [alicloud_vpc.main]
}
resource "alicloud_nat_gateway" "main" {
  vpc_id        = alicloud_vpc.main.id
  specification = "Small"
  name          = "from-tf-example"
}

resource "alicloud_eip" "foo" {
}

resource "alicloud_eip_association" "foo" {
  allocation_id = alicloud_eip.foo.id
  instance_id   = alicloud_nat_gateway.main.id
}
