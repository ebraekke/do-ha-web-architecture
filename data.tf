data "digitalocean_ssh_key" "main" {
    name = var.ssh_main_key
}

data "digitalocean_ssh_key" "jump" {
    name = var.ssh_jump_key
}


data "digitalocean_domain" "web" {
    name = var.domain_name
}

# Create bastion user data 
data "template_file" "bastion" {
  template = file("${path.module}/templates/bastion.tpl")
  vars = {
    jump_key        = data.digitalocean_ssh_key.jump.public_key
    super_user      = "root"
  }
}
