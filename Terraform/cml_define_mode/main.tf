terraform {
  required_providers {
    cml2 = {
      source = "registry.terraform.io/ciscodevnet/cml2"
    }
  }
}

provider "cml2" {
  address = var.address
  username = var.username
  password = var.password
  skip_verify = true
}

resource "cml2_lab" "this" {
  title       = "Test"
  description = "Terraform Test lab"
}

resource "cml2_node" "ext" {
  lab_id         = cml2_lab.this.id
  nodedefinition = "external_connector"
  label          = "Internet"
  configuration  = jsonencode({ bridge = "bridge0" })
  x              = -750
  y              = 0
}

resource "cml2_node" "r1" {
  lab_id         = cml2_lab.this.id
  label          = "Linux PC"
  nodedefinition = "alpine"
  x              = -750
  y              = 150
}

resource "cml2_link" "l1" {
  lab_id = cml2_lab.this.id
  node_a = cml2_node.ext.id
  node_b = cml2_node.r1.id
}

resource "cml2_lifecycle" "runner" {
  lab_id = cml2_lab.this.id
  depends_on = [
    cml2_node.ext,
    cml2_node.r1,
    cml2_link.l1
  ]
}