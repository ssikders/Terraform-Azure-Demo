
rgname = "RG-VM-DEMO"
location = "WEST US2"
vmname = "AZ-VM-01"
vm_size = "Standard_D2s_v5"
admin_username = "AzureAdmin"
admin_password = "ChangeMe2022@"

os = {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter"
    version   = "latest"
}

# Variables Input From Existing Resources
vnetrg = "RG-WEST-US2-CORE"
vnetname = "VNET-WEST-US2-CORE"
subnetname = "SNET-INF"


# Variables for Existing Domain Resources
 active_directory_domain    = "cloudchakra.co.uk"
 ou_path                    = "CN=Computers,DC=cloudchakra,DC=co,DC=uk"
 active_directory_username  = "OpsAdmin"
 active_directory_password  = "Changeme2022##"