terraform {
  required_version = ">=1.5.0"
  required_providers {
    azurem = {
      source = "hashicorp/azurerm",
      version = "~> 3.0"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
  name      = "rg-rp002-learn-iaac-cicd"
  location  = "South India"
}

resource "azurerm_container_registry" "acr" {
  name                = "acrrp002learniaaccicd"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku                 = "Basic"
  admin_enabled       = true
}

resource "azurerm_log_analytics_workspace" "law" {
  name                = "law-rp002-learn-iaac-cicd"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

resource "azurerm_container_app_environment" "env" {
  name                        = "cae-rp002-learn-iaac-cicd"
  resource_group_name         = azurerm_resource_group.rg.name
  location                    = azurerm_resource_group.rg.location
  log_analytics_workspace_id  = azurerm_log_analytics_workspace.law.id
}

resource "azurerm_container_app" "app" {
  name                          = "ca-rp002-learn-iaac-cicd"
  container_app_environment_id  = azurerm_container_app_environment.env.id
  resource_group_name           = azurerm_resource_group.rg.name
  revision_mode                 = "Single"

  registry {
    server                  = azurerm_container_registry.acr.login_server
    username                = azurerm_container_registry.acr.admin_username
    password_secret_name    = "acr_password"
  }

  secret {
    name  = "acr_password"
    value = azurerm_container_registry.acr.admin_password
  }

  ingress {
    allow_insecure_connections = false # Enforces strict HTTPS
    external_enabled           = true  # Generates a public proxy URL
    target_port                = 3000  # Routes incoming traffic to Node's internal port
    traffic_weight {
      percentage      = 100
      latest_revision = true
    }
  }

  template {
    container {
      name   = "node-api"
      image  = "://microsoft.com" # Temporary bootstrap image
      cpu    = "0.25"
      memory = "0.5Gi"
      
      env {
        name  = "NODE_ENV"
        value = "production"
      }
    }
  }
}

output "public_proxy_url" {
  value       = "https://${azurerm_container_app.app.ingress[0].fqdn}/api/data" # FQDN : fully qualified domain name
  description = "The public proxy URL to access your public Node.js API data endpoint"
  
}