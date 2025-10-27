


module "bastion" {
    source                  = "./modules/bastion"

    # Bastion needs to be most recent ubuntu
    image                   = var.image
    name                    = var.name
    region                  = var.region
    ssh_key                 = data.digitalocean_ssh_key.main.id
    user_data               = local.user_data_bastion
    vpc_id                  = digitalocean_vpc.web.id
    ip_allow_range          = var.ip_allow_range 
    
    do_token                = var.do_token        
}
