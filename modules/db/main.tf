################################################################################
# Create n db servwers                                                         #
################################################################################
resource "digitalocean_droplet" "db" {

    count = var.instance_count

    # Which image to use. Taken from our variables
    image = var.image

    # human friendly name for the droplet
    name = "db${count.index + 1 }"

    # What region to deploy the droplet(s) to. Taken from our variables
    region = var.region
    
    # Size of the DB host.
    size = var.size

    # The ssh keys to put on the server so we can access it. Read in through a 
    # data source
    ssh_keys = [var.ssh_key]

    user_data = var.user_data
        
    # What VPC to put the DB node8s) in
    vpc_uuid = var.vpc_id

    #-----------------------------------------------------------------------------------------------#
    # Ensures that we create the new resource before we destroy the old one                         #
    # https://www.terraform.io/docs/configuration/resources.html#lifecycle-lifecycle-customizations #
    #-----------------------------------------------------------------------------------------------#
    lifecycle {
        create_before_destroy = true
    }
}


################################################################################
# Create firewall rules for allowing DB to DB specific traffic                 #
################################################################################
resource "digitalocean_firewall" "db-to-db" {
    
    # Human friendly name of the firewall
    name = "${var.name}-db-to-db"

    # Droplets to apply the firewall to
    droplet_ids = digitalocean_droplet.db.*.id

    #--------------------------------------------------------------------------#
    #  Allow 3306, 33060 and 33061 between all DB nodes                        #
    #--------------------------------------------------------------------------#
    inbound_rule {
        protocol = "tcp"
        port_range = "22"
        source_addresses = [var.ip_allow_range]
    }

    inbound_rule {
        protocol = "tcp"
        port_range = "3306"
        source_addresses = [var.ip_allow_range]
    }

    inbound_rule {
        protocol = "tcp"
        port_range = "33060"
        source_addresses = [var.ip_allow_range]
    }

    inbound_rule {
        protocol = "tcp"
        port_range = "33061"
        source_addresses = [var.ip_allow_range]
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