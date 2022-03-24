terraform {
required_providers {
azurerm = {
source = "hashicorp/azurerm"
version = "~> 2.65"
}
}



required_version = ">= 1.1.0"
}



provider "azurerm" {
features {}
}



resource "azurerm_resource_group" "resourcegroup" {
name = "RSG-Teamone"
location = "Korea Central"
}

# resource "azurerm_virtual_network" "virtualnetwork" {
# name = "team2network"
# location = azurerm_resource_group.resourcegroup.location
# resource_group_name = azurerm_resource_group.resourcegroup.name
# address_space = ["10.0.0.0/16"]
# }
resource "azurerm_app_service_plan" "app-plan" {
name = "team1serviceplan"
location = azurerm_resource_group.resourcegroup.location
resource_group_name = azurerm_resource_group.resourcegroup.name


sku {
tier = "Standard"
size = "F1"
}
}

resource "azurerm_app_service" "webapp" {
name = "team1-wep-app"
location = azurerm_resource_group.resourcegroup.location
resource_group_name = azurerm_resource_group.resourcegroup.name
app_service_plan_id = azurerm_app_service_plan.app-plan.id


app_settings = {
"SOME_KEY" = "some-value"
}
connection_string {
name = "Database"
type = "SQLServer"
value = "Server=some-server.mydomain.com;Integrated Security=SSPI"
}
source_control {

     repo_url = "https://github.com/WordPress/WordPress"

     branch = "master"

     use_mercurial = false
     manual_integration = true
     

 }
}

resource "azurerm_mysql_server" "mysql-server" {
name = "team1mysqlserver"
location = azurerm_resource_group.resourcegroup.location
resource_group_name = azurerm_resource_group.resourcegroup.name



administrator_login = "team1lbn"
administrator_login_password = "Team1Okeluon"



 sku_name = "B_Gen5_2"
 storage_mb = 5120
 version = "5.7"



 auto_grow_enabled = false
 public_network_access_enabled = true
 ssl_enforcement_enabled = false
 ssl_minimal_tls_version_enforced = "TLSEnforcementDisabled"
}
resource "azurerm_mysql_database" "app-database" {
name = "team1appdatabase"
resource_group_name = azurerm_resource_group.resourcegroup.name
server_name = azurerm_mysql_server.mysql-server.name
 charset = "utf8"
 collation = "utf8_unicode_ci"
}







# resource "null_resource" "database_setup" {
#   provisioner "local-exec" {
#       command = "mysqlcmd -S team1mysqlserver.database.windows.net -U team1lbn -P Team1Okeluon -d app-database -i init.mysql"
#   }
#   depends_on=[
#     azurerm_mysql_server.team1mysqlserver
#   ]
# }
