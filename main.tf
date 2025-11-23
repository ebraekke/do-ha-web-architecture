


module "bastion" {
    source                  = "./modules/bastion"

    # Bastion needs to be most recent ubuntu
    image                   = "ubuntu-24-04-x64"
    name                    = var.name
    region                  = var.region
    ssh_key                 = data.digitalocean_ssh_key.jump.id
    user_data               = local.user_data_standard
    vpc_id                  = digitalocean_vpc.web.id
    ip_allow_range          = var.ip_allow_range 
    
    do_token                = var.do_token        
}

module "db" {
    source                  = "./modules/db"

    # Let's standardizxe on Ubunti 
    image                   = "ubuntu-24-04-x64"
    name                    = var.name
    region                  = var.region
    ssh_key                 = data.digitalocean_ssh_key.main.id
    user_data               = local.user_data_standard
    vpc_id                  = digitalocean_vpc.web.id
    ip_allow_range          = var.ip_allow_range 
    
    do_token                = var.do_token        
}
