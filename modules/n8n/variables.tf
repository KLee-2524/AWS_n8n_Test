variable "instance_type" {
  description = "Type of EC2 instance to provision"
  default     = "t2.micro"
}

variable "n8n_ami" {
    description = "AMI of the n8n VM to deploy"
    type        = string
    default     = "ami-0507f5acd9ba8e6b7"
}

variable "vpc_id" {
    description = "ID of the lab vpc"
    type        = string
}

variable "route_table_id" {
    description = "ID of the route table"
    type        = string
}

variable "attendee_number" {
    description = "Used to create separate subnets for each individual attendee. This value cannot be greater than 255."
    type        = string
}

variable "n8n_setup_script" {
    description = "Set script to configure n8n Linux VM upon deployment"
    type        = string
    default     = <<-EOT
    #!/bin/bash
    export DEBIAN_FRONTEND=noninteractive
    mkdir /home/ubuntu/TEST
    echo "TEST directory created" > /home/ubuntu/TEST/setup_log.txt
    apt update -y
    echo "apt update initiated" > /home/ubuntu/TEST/setup_log.txt

    sudo apt-get update -y
    sudo apt-get full-upgrade -y
    echo "apt-get udpate & upgrade initiated" >> /home/ubuntu/TEST/setup_log.txt
    EOT
}