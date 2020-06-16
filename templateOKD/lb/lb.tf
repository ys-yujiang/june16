
resource "azurerm_lb" "lbapi" {
  name                = "LBAPI${var.cluster_name}"
  location            = "${var.rg_location}"
  resource_group_name = "${var.rg_name}"

  frontend_ip_configuration {
    name                 = "LoadBalancerFrontEnd"
    subnet_id            = "/subscriptions/cac268a6-eb37-4048-a645-34b79e063341/resourceGroups/RSGNETP001/providers/Microsoft.Network/virtualNetworks/DCVNETWP001/subnets/DC_IaaS_SRV"
  }
}

resource "azurerm_lb_backend_address_pool" "lbapi" {
  resource_group_name = "${var.rg_name}"
  loadbalancer_id     = "${azurerm_lb.lbapi.id}"
  name                = "Master_Backend_Pool"
}

resource "azurerm_lb_probe" "lbapi" {
  resource_group_name = "${var.rg_name}"
  loadbalancer_id     = "${azurerm_lb.lbapi.id}"
  name                = "Master_Health_Probe"
  port                = 8443
  protocol            = "Tcp"
}

resource "azurerm_lb_rule" "example" {
  resource_group_name            = "${var.rg_name}"
  loadbalancer_id                = "${azurerm_lb.lbapi.id}"
  name                           = "Master_Rule"
  protocol                       = "Tcp"
  frontend_port                  = 8443
  backend_port                   = 8443
  frontend_ip_configuration_name = "LoadBalancerFrontEnd"
  backend_address_pool_id        = "${azurerm_lb_backend_address_pool.lbapi.id}"
  probe_id                       = "${azurerm_lb_probe.lbapi.id}"
}

resource "azurerm_lb" "lbrouter" {
  name                = "LBROUTER${var.cluster_name}"
  location            = "${var.rg_location}"
  resource_group_name = "${var.rg_name}"

  frontend_ip_configuration {
    name                 = "LoadBalancerFrontEnd"
    subnet_id            = "/subscriptions/cac268a6-eb37-4048-a645-34b79e063341/resourceGroups/RSGNETP001/providers/Microsoft.Network/virtualNetworks/DCVNETWP001/subnets/DC_IaaS_SRV"
  }
}

resource "azurerm_lb_backend_address_pool" "lbrouter" {
  resource_group_name = "${var.rg_name}"
  loadbalancer_id     = "${azurerm_lb.lbrouter.id}"
  name                = "Infra_Backend_Pool"
}

resource "azurerm_lb_probe" "lbrouter_01" {
  resource_group_name = "${var.rg_name}"
  loadbalancer_id     = "${azurerm_lb.lbrouter.id}"
  name                = "Infra_Health_Probe_01"
  port                = 80
  protocol            = "Tcp"
}

resource "azurerm_lb_probe" "lbrouter_02" {
  resource_group_name = "${var.rg_name}"
  loadbalancer_id     = "${azurerm_lb.lbrouter.id}"
  name                = "Infra_Health_Probe_02"
  port                = 443
  protocol            = "Tcp"
}


output "id_lbapi" {
  value = "${azurerm_lb.lbapi.id}"
}

output "id_lbrouter" {
  value = "${azurerm_lb.lbrouter.id}"
}