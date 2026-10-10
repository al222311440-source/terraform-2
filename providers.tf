provider "azurerm" {
  features {}
  # ARM_SUBSCRIPTION_ID se obtiene de la sesión real de Azure CLI.
  resource_provider_registrations = "none"
}
