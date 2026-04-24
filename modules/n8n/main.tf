resource "aws_subnet" "n8n-subnet" {
  vpc_id                  = var.vpc_id
  cidr_block              = "172.16.${var.attendee_number}.0/24"
  availability_zone       = "us-west-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "n8n-subnet-${var.attendee_number}"
  }
}

resource "aws_route_table_association" "n8n-subnet" {
  subnet_id      = aws_subnet.n8n-subnet.id
  route_table_id = var.route_table_id
}

# SECURITY GROUP #
resource "aws_security_group" "n8n-sg" {
  name   = "n8n-sg-${var.attendee_number}"
  vpc_id = var.vpc_id

  ingress {
    from_port  = 22
    to_port    = 22
    protocol   = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Either from 8 + to -1 or from -1 + to -1
  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = [aws_subnet.n8n-subnet.cidr_block]
  }

  egress {
    from_port  = 0
    to_port    = 0
    protocol   = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "n8n-vm" {
  ami           = var.n8n_ami
  instance_type = var.instance_type
  subnet_id     = aws_subnet.n8n-subnet.id
  
  vpc_security_group_ids = [aws_security_group.n8n-sg.id]

  user_data = var.n8n_setup_script

  key_name = "terraform-key-pair"

  tags = {
    Name = "n8n-VM-${var.attendee_number}"
  }
}