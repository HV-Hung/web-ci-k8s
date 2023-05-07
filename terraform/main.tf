provider "azurerm" {
  features {}
}


resource "azurerm_resource_group" "aks" {
  name     = "my-aks-resource-group"
  location = "southeastasia"
}

resource "azurerm_kubernetes_cluster" "k8s" {
  name                = "k8s-cluster"
  location            = azurerm_resource_group.aks.location
  resource_group_name = azurerm_resource_group.aks.name
  dns_prefix          = "k8s-cluster"

  linux_profile {
    admin_username = "adminuser"
    ssh_key {
      key_data = file("~/.ssh/pingping.pub")
    }
  }

  default_node_pool {
    name            = "default"
    vm_size         = "Standard_DS2_v2"
    node_count      = 1
    os_disk_size_gb = 30
  }
  identity {
    type = "SystemAssigned"
  }

   network_profile {
    load_balancer_sku = "standard"
    network_plugin    = "kubenet" 
  }

  tags = {
    environment = "dev"
  }
}

