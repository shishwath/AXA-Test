terraform{
    backend "azurerm" {
        resource_group_name = "store-rg"
        storage_account_name = "myaxadtstrg"
        container_name = "myaxacontainer"
        key  = "mydir/mystatefile.tfstate"
    }
}
