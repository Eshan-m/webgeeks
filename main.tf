provider "azurerm" {
  features {}
  subscription_id = "f5dac2a4-4260-4510-8cd5-55145975adfb"
}

# Variables
variable "admin_username" {
  description = "Admin username for the VM"
  default     = "azureuser"
}

variable "admin_password" {
  description = "Admin username for the VM"
  default     = "Azure@123456"
}

variable "vm_size" {
  description = "Size of the VM"
  default     = "Standard_B2s"
}

# Data for existing resources
data "azurerm_resource_group" "rg" {
  name = "capstone"
}

data "azurerm_public_ip" "static_ip" {
  name                = "static_ip"
  resource_group_name = data.azurerm_resource_group.rg.name
}

# Virtual Network and Subnet
resource "azurerm_virtual_network" "vm_vnet" {
  name                = "capstone-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
}

resource "azurerm_subnet" "vm_subnet" {
  name                 = "capstone-subnet"
  resource_group_name  = data.azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vm_vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

# Network Security Group
resource "azurerm_network_security_group" "vm_nsg" {
  name                = "capstone-vm-nsg"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name

  security_rule {
    name                       = "allow-http"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  
security_rule {
  name                       = "allow-ssh"
  priority                   = 110
  direction                  = "Inbound"
  access                     = "Allow"
  protocol                   = "Tcp"
  source_port_range          = "*"
  destination_port_range     = "22"
  source_address_prefix      = "*"
  destination_address_prefix = "*"
}


  security_rule {
    name                       = "allow-8080"
    priority                   = 200
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "8080"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "allow-sql-server"
    priority                   = 300
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "1433"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

# Network Interface
resource "azurerm_network_interface" "vm_nic" {
  name                = "capstone-vm-nic"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "primary"
    subnet_id                     = azurerm_subnet.vm_subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = data.azurerm_public_ip.static_ip.id
  }
}

# Associate the NSG with the NIC
resource "azurerm_network_interface_security_group_association" "nsg_association" {
  network_interface_id      = azurerm_network_interface.vm_nic.id
  network_security_group_id = azurerm_network_security_group.vm_nsg.id
}

# # Virtual Machine
# resource "azurerm_linux_virtual_machine" "vm" {
#   name                = "capstone-docker-vm"
#   resource_group_name = data.azurerm_resource_group.rg.name
#   location            = data.azurerm_resource_group.rg.location
#   size                = var.vm_size
#   admin_username      = var.admin_username
#   disable_password_authentication = true

#   admin_ssh_key {
#     username   = var.admin_username
#     public_key = file("~/.ssh/id_rsa.pub") # Path to your public SSH key
#   }

#   network_interface_ids = [
#     azurerm_network_interface.vm_nic.id,
#   ]

#   os_disk {
#     caching              = "ReadWrite"
#     storage_account_type = "Standard_LRS"
#     disk_size_gb         = 64
#   }

#   source_image_reference {
#     publisher = "Canonical"
#     offer     = "0001-com-ubuntu-server-jammy"
#     sku       = "22_04-lts-gen2"
#     version   = "latest"
#   }

#   # File provisioner to upload the script
#   # provisioner "file" {
#   #   source      = "setup.sh"           # Path to your setup script
#   #   destination = "/tmp/setup.sh"      # Destination on the VM

#   #   connection {
#   #     type        = "ssh"
#   #     user        = var.admin_username
#   #     private_key = file("~/.ssh/id_rsa")  # Path to your private SSH key
#   #     host        = data.azurerm_public_ip.static_ip.ip_address
#   #   }
#   # }

#   # Remote-exec provisioner to execute the script
#   provisioner "remote-exec" {
#     inline = [
#     "git clone --branch QA https://github.com/Eshan-m/webgeeks.git"
#       # "chmod +x /tmp/setup.sh",
#       # "sudo /tmp/setup.sh ${var.admin_username}"
#     ]

#     connection {
#       type        = "ssh"
#       user        = var.admin_username
#       private_key = file("~/.ssh/id_rsa")  # Path to your private SSH key
#       host        = data.azurerm_public_ip.static_ip.ip_address
#     }
#   }

#   tags = {
#     Environment = "Capstone"
#   }
# }


resource "azurerm_linux_virtual_machine" "vm" {
  name                = "capstone-docker-vm"
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = data.azurerm_resource_group.rg.location
  size                = var.vm_size
  admin_username      = var.admin_username
  admin_password      = var.admin_password  # Define the password here
  disable_password_authentication = false  # Allow password authentication

  network_interface_ids = [
    azurerm_network_interface.vm_nic.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
    disk_size_gb         = 64
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }

 
  provisioner "file" {
    source      = "setup.sh"           # Path to your setup script
    destination = "/tmp/setup.sh"      # Destination on the VM

    connection {
      type        = "ssh"
      user        = var.admin_username
      password    = var.admin_password  # Use password for authentication
      host        = data.azurerm_public_ip.static_ip.ip_address
    }
  }

  # Remote-exec provisioner to execute the script
  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/setup.sh",
      "sudo /tmp/setup.sh ${var.admin_username}"
    ]

    connection {
      type        = "ssh"
      user        = var.admin_username
      password    = var.admin_password  # Use password for authentication
      host        = data.azurerm_public_ip.static_ip.ip_address
    }
  }

  tags = {
    Environment = "Capstone"
  }
}

