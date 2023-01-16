terraform {
  required_version = ">= 0.12"
  required_providers {
    azurerm = ">= 3.0"
  }
}

provider "azurerm" {
    features {
        resource_group {
            prevent_deletion_if_contains_resources = false
        }
    }
}

# RG
resource "azurerm_resource_group" "rg-153132" {
  name     = var.rg
  location = var.location
}

# Storage Account
resource azurerm_storage_account "sa-153132" {
  name                     = var.sa
  resource_group_name      = azurerm_resource_group.rg-153132.name
  location                 = azurerm_resource_group.rg-153132.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind             = "StorageV2"
  enable_https_traffic_only = true
}

resource azurerm_storage_container "sc-153132" {
  name                  = var.sc
  storage_account_name  = azurerm_storage_account.sa-153132.name
  container_access_type = "private"
}

resource azurerm_storage_blob "sb-153132" {
  name                   = var.sb
  storage_account_name   = azurerm_storage_account.sa-153132.name
  storage_container_name = azurerm_storage_container.sc-153132.name
  type                   = "Block"
  source                 = "README.md"
}

# Networking

resource azurerm_virtual_network "vnet-153132" {
  name                = var.vnet
  resource_group_name = azurerm_resource_group.rg-153132.name
  location            = azurerm_resource_group.rg-153132.location
  address_space       = ["192.168.0.0/16"]
}

resource azurerm_subnet "subnet-153132" {
  name                 = var.vmsubnet
  resource_group_name  = azurerm_resource_group.rg-153132.name
  virtual_network_name = azurerm_virtual_network.vnet-153132.name
  address_prefixes     = ["192.168.0.0/24"]
}

resource azurerm_network_interface "nic-153132" {
  name                = var.nicname
  resource_group_name = azurerm_resource_group.rg-153132.name
  location            = azurerm_resource_group.rg-153132.location
  ip_configuration {
    name                          = var.ipconfigname
    subnet_id                     = azurerm_subnet.subnet-153132.id
    private_ip_address_allocation = "Dynamic"
  }
}

# Private link
resource azurerm_private_dns_zone "pdz-153132" {
  name                = var.pdzname
  resource_group_name = azurerm_resource_group.rg-153132.name
}

resource azurerm_private_dns_zone_virtual_network_link "pdzvnl-153132" {
  name                  = var.pdzvnlname
  resource_group_name   = azurerm_resource_group.rg-153132.name
  private_dns_zone_name = azurerm_private_dns_zone.pdz-153132.name
  virtual_network_id    = azurerm_virtual_network.vnet-153132.id
  registration_enabled  = false
}

resource azurerm_private_endpoint "pe-153132" {
  name                = var.pename
  location            = azurerm_resource_group.rg-153132.location
  resource_group_name = azurerm_resource_group.rg-153132.name
  subnet_id           = azurerm_subnet.subnet-153132.id
  private_service_connection {
    name                           = var.pscname
    is_manual_connection           = false
    private_connection_resource_id = azurerm_storage_account.sa-153132.id
    subresource_names              = ["blob"]
  }
  private_dns_zone_group {
    name = var.pdzgname
    private_dns_zone_ids = [azurerm_private_dns_zone.pdz-153132.id]
  }
}

# Vritual Machine
resource azurerm_virtual_machine "vm-153132" {
  name                  = var.vmname
  resource_group_name   = azurerm_resource_group.rg-153132.name
  location              = azurerm_resource_group.rg-153132.location
  network_interface_ids = [azurerm_network_interface.nic-153132.id]
  vm_size               = "Standard_B1s"
  delete_os_disk_on_termination = true
  delete_data_disks_on_termination = true
  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
  storage_os_disk {
    name              = "osdisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = var.vm
    admin_username = var.adminuser
    admin_password = var.adminpassword
  }
  os_profile_linux_config {
    disable_password_authentication = false
  }
  boot_diagnostics {
    enabled     = true
    storage_uri = azurerm_storage_account.sa-153132.primary_blob_endpoint
  }
}