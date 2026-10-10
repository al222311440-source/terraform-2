# Terraform 2 — Felipe de Jesús Serrano Hurtado

Configuración desplegada y verificada en Azure. El último plan muestra `No changes. Your infrastructure matches the configuration.` Repositorio de entrega: https://github.com/al222311440-source/terraform-2. Cuenta de entrega autorizada: `al222311440-source`.

## Origen y alcance

Base: https://github.com/jorgealmeidamontiel/terraform-laboratories/tree/main/segundo-programa

Commit del profesor auditado: `9d0eb0eb0ec423248007a0df5e7031c29d138e8f`.
La carpeta original contiene 14 videos y un archivo de comandos, sin archivos `.tf`. Se inspeccionaron fotogramas de todos los videos y fotogramas adicionales del código. No se afirma haber transcrito todo el audio. La configuración final de los videos 11–15 muestra un Resource Group y una red virtual en `mexicocentral`.

## Configuración

- `terraform.tf`: requisitos de Terraform y AzureRM.
- `providers.tf`: proveedor AzureRM con registro automático deshabilitado.
- `variables.tf`, `locals.tf` y `practice.tfvars`: entradas tipadas, nombres y etiquetas.
- `main.tf`: grupo de recursos y red virtual.
- `outputs.tf`: nombres, identificadores y espacio de direcciones.
- `.terraform.lock.hcl`: AzureRM 5.9.0 y checksums.
- `evidencias/`: registros textuales reales de ejecución.

Se corrigieron dos incompatibilidades de las versiones transitorias de los videos: `vnet_address_space` utiliza `list(string)` y `tags` utiliza `map(string)` con valor predeterminado `{}`. Se usa `ARM_SUBSCRIPTION_ID` obtenido de la sesión real, sin copiar la suscripción del profesor. No se añadieron subredes, máquinas virtuales ni otros recursos.

## Ejecución real

Se utilizó Azure Cloud Shell Bash, autenticado en la cuenta institucional indicada para la práctica. Se comprobó la suscripción activa y que el grupo de recursos de esta práctica no existía. `Microsoft.Network` estaba `NotRegistered`; se registró y se verificó `Registered` antes de planificar.

```bash
az account show --query '{user:user.name,subscription:name,id:id}' -o json
export ARM_SUBSCRIPTION_ID="$(az account show --query id -o tsv)"
az provider show --namespace Microsoft.Network --subscription "$ARM_SUBSCRIPTION_ID" --query registrationState -o tsv
# Ejecutado porque el proveedor todavía no estaba registrado:
az provider register --namespace Microsoft.Network --subscription "$ARM_SUBSCRIPTION_ID" --wait
terraform fmt -check -recursive
terraform init -no-color
terraform validate -no-color
terraform plan -var-file=practice.tfvars -out=practice.tfplan -no-color
# Tras revisar dos creaciones y ninguna modificación ni eliminación:
terraform apply -no-color practice.tfplan
terraform output -json
terraform plan -var-file=practice.tfvars -detailed-exitcode -no-color
```

## Resultados

| Comprobación | Resultado observado |
| --- | --- |
| Terraform en Cloud Shell | 1.16.4 |
| Azure CLI en Cloud Shell | 2.90.0 |
| AzureRM | 5.9.0 |
| Formato e inicialización | Correctos |
| Validación | Success! The configuration is valid. |
| Plan inicial | 2 to add, 0 to change, 0 to destroy |
| Apply | 2 added, 0 changed, 0 destroyed |
| Grupo de recursos | rg-integradora-dev-mexicocentral-001, Succeeded |
| Red virtual | vnet-integradora-dev-mexicocentral-001, Succeeded |
| Dirección y región | 10.10.0.0/16, mexicocentral |
| Plan posterior | Sin cambios |

Los registros del intento local anterior se conservan como evidencia histórica: el proveedor no podía abrir un socket Unix en ese entorno. La validación y el despliegue posteriores sí se completaron en Cloud Shell. Los logs son texto real; las capturas del informe provienen del navegador durante la ejecución.

## Estado y limpieza

No se ejecutó `terraform destroy`. El estado real se respaldó por separado y no se publica en Git. Los archivos de estado, los planes y las credenciales están excluidos mediante `.gitignore`. Para administrar estos recursos se debe recuperar ese estado; no ejecutar otro apply desde una carpeta vacía suponiendo que los recursos no existen.

Esta práctica declara únicamente el grupo de recursos y la red virtual. Cualquier eliminación posterior debe limitarse a los recursos creados para esta práctica y autorizarse expresamente.

## Datos ocultos en los registros públicos

Los registros publicados conservan los resultados técnicos, pero reemplazan el identificador de la suscripción por `[SUBSCRIPTION_ID_OCULTO]` y la cuenta institucional por `[CUENTA_INSTITUCIONAL_OCULTA]`. Los originales y el estado real se conservan por separado. Ningún commit público incluye estados, credenciales, planes binarios ni capturas con contexto de cuenta.
