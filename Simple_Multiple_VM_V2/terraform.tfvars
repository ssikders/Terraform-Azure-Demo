
rgname = "RG-VM-DEMO"
location = "WEST US2"
vmname = "AZ-VM"
node_count = 2
vm_size = "Standard_B2s"
admin_username = "AzureAdmin"
admin_password = "ChangeMe2022@"
vnetname = "VNET-DEMO"
subnetname = "SNET-INF"
vnet_address_space = ["10.10.0.0/21"]
snet_address_space = ["10.10.1.0/24"]
os = {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter"
    version   = "latest"
}