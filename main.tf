# NETWORKING #
resource "aws_vpc" "n8n-vpc" {
  cidr_block           = "172.16.0.0/16"
  enable_dns_hostnames = true

  tags = {
    Name = "n8n-vpc"
  }
}

resource "aws_internet_gateway" "n8n-gateway" {
  vpc_id = aws_vpc.n8n-vpc.id
}

# ROUTING #
resource "aws_route_table" "n8n-route-table" {
  vpc_id = aws_vpc.n8n-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.n8n-gateway.id
  }
}

variable "attendee_usernames" {
  type = list(string)

  default = [
    "n8n_server_1"
  ]
}


locals {
  attendee_index_map = zipmap(var.attendee_usernames, range(length(var.attendee_usernames)))
}


module "n8n" {
    source = "./modules/n8n"
    for_each = local.attendee_index_map

    attendee_number = each.value
    vpc_id          = aws_vpc.n8n-vpc.id
    route_table_id  = aws_route_table.n8n-route-table.id
}