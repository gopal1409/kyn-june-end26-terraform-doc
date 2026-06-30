#lets disable the linux vm 
#before that run terraform destroy
#then go to a11.linuxvm.tf in the starting put /* and end of the line */
  #then go to azure portal search for Key vaults
  #create a new one 
  #create a new resource group gopal-win-vault 
  #give a name to your vault gopal-vault
  ###then create it
  #then expand object 
  #click on secret give a click on generate import
  #give a name and a value which will be your password Admin@12345678
#lets call the vault create a new file a13.vault.tf
#in this data block we are calling the vault
data "azurerm_key_vault" "existing_kv" {
  name                = "gopal-vault" #change it to your name of the vault 
  resource_group_name = "gopal-win-vault" #change it to your resource group name of the vault
}

output "vault_uri" {
  value = data.azurerm_key_vault.existing_kv.vault_uri
}

#second we need to call the secret from the vault
data "azurerm_key_vault_secret" "vm_password" {
    name         = "win-pass" #change it to secret name created inside the vault
    key_vault_id = data.azurerm_key_vault.existing_kv.id
}
#you need to open cloud shell run this command 
KV_ID=$(az keyvault show --name gopal-win-vault --resource-group gopal-vault --query id -o tsv)

Assign the role:

az role assignment create --assignee 48526d55-b2fc-4a55-96ff-22845f827cb8 --role "Key Vault Secrets User" --scope $KV_ID
#lets open port 3389 replace port 22 to 3389 in a8.nsg
#lets create a new file a13.windowsvm.tf
resource "azurerm_windows_virtual_machine" "web_vm" {

  name                = "${local.resource_name_prefix}-win11vm"
  location            = azurerm_resource_group.myrg.location
  resource_group_name = azurerm_resource_group.myrg.name

  size = "Standard_D2s_v3" 

  admin_username = "azureuser"

  admin_password = data.azurerm_key_vault_secret.vm_password.value

  network_interface_ids = [
    azurerm_network_interface.web_nic.id
  ]

  provision_vm_agent          = true
  enable_automatic_updates    = true

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsDesktop"
    offer     = "windows-11"
    sku       = "win11-25h2-pro"
    version   = "latest"
  }

  tags = local.project_lucky
}

#after this do terraform apply
once you get the public ip open rdp
#put the public ip and connect put username as azureuser and password you store inside vault
