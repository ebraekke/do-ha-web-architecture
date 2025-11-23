
# variables for readbility in complex statements
locals {
    user_data_standard = file("${path.module}/templates/standard.tpl")

    user_data_bastion = templatefile("${path.module}/templates/bastion.tpl", {
        jump_key   = data.digitalocean_ssh_key.jump.public_key
        super_user = "root"
  })
}
