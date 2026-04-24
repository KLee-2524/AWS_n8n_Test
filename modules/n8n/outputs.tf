output "n8n_details" {
    value = {
        name = aws_instance.n8n-vm.tags["Name"]
        pub_ip = aws_instance.n8n-vm.public_ip
    }
    description = "n8n Linux EC2 instance name"
}