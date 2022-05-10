# Domain Join
module "domain-join" {
source  = "kumarvna/domain-join/azurerm"
version = "1.1.0"

  virtual_machine_id        = azurerm_windows_virtual_machine.vm.id
  active_directory_domain   = var. active_directory_domain
  active_directory_username = var.active_directory_username
  active_directory_password = var.active_directory_password

}