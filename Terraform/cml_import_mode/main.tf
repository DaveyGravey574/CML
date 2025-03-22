terraform {
  required_providers {
    cml2 = {
      source  = "registry.terraform.io/ciscodevnet/cml2"
    }
  }
}

provider "cml2" {
    address = var.address
    username = var.username
    password = var.password
    skip_verify = true
}

resource "cml2_lifecycle" "ios_lab" {
    topology = templatefile("topology.yml", {labname = "Dave's Lab" })
}