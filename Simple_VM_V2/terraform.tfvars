
rgname = "RG-VM-DEMO"
location = "WEST US2"
vmname = "AZ-VM-01"
vm_size = "Standard_D2s_v5"
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