terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }
}

provider digitalocean {
    # Our DigitalOcean token. Taken from our variables
    token = var.do_token
}
