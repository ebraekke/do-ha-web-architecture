################################################################################
# Create n web servers with nginx installed and a custom message on main page  #
################################################################################
resource "digitalocean_droplet" "bastion" {

    # Which image to use. Taken from our variables
    image = var.image

    # human friendly name for the droplet
    name = "bastion-${var.name}-${var.region}"

    # What region to deploy the droplet(s) to. Taken from our variables
    region = var.region
    
    # Size of the bastion. Can be small since it's only doing ssh
    size = var.size

    # The ssh keys to put on the server so we can access it. Read in through a 
    # data source
    ssh_keys = [var.ssh_key]

    user_data = var.user_data
        
    # What VPC to put our droplets in
    vpc_uuid = var.vpc_id
}


################################################################################
# Create firewall rules for allowing only ssh traffic to and from the bastion  #
################################################################################
resource "digitalocean_firewall" "bastion" {
    
    # Human friendly name of the firewall
    name = "${var.name}-only-ssh-bastion"

    # Droplets to apply the firewall to
    droplet_ids = [digitalocean_droplet.bastion.id]

    #--------------------------------------------------------------------------#
    # Rules to allow only ssh both inbound from the public internet and only   #
    # allow outbout ssh traffic into the VPC network. Also allow ping just for #
    # ease of use inside the VPC as well.                                      #
    #--------------------------------------------------------------------------#
    inbound_rule {
        protocol = "tcp"
        port_range = "22"
        source_addresses = ["0.0.0.0/0", "::/0"]
    }

    outbound_rule {
        protocol = "tcp"
        port_range = "22"
        destination_addresses = [var.ip_allow_range]
    }

    outbound_rule {
        protocol = "icmp"
        destination_addresses = [var.ip_allow_range]
    }

}