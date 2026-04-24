output "lab_instances" {
    value = {
        for attendee, mod in module.n8n :
        attendee => {
            n8n_name   = module.n8n["${attendee}"].n8n_details.name
            n8n_pub_ip = module.n8n["${attendee}"].n8n_details.pub_ip
        }
    }
}