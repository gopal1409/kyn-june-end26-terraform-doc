terraform destroy
##lets create a map varaibles for the instance a14.vm-size.tf
  variable "vm_size" {
  description = "The size of the virtual machine"
  type        = map(string)
  default     = {
    dev  = "Standard_B1s"
    test = "Standard_F2"
    prod = "Standard_D2s_v3"
  }   
}

##how to use the same inside a11.linuxvm.tf
  #look for the line size of the instance like below where it is showing instance size delete that and replace it with 
    size                = var.vm_size["dev"]
  ##after this do terraform apply
  #then go to to azure portal and check the instance size 
  #after checking change the instance size to 
    size                = var.vm_size["test"]
  #do terraform apply this will modify the instance type to 2 core 4 Gb ram
  ##do not forget to do terraform destroy
