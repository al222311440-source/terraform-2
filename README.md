# Terraform 2 — Felipe de Jesús Serrano Hurtado

Estado: configuración reconstruida; fmt e init correctos. Validate bloqueado por la restricción de sockets del entorno; despliegue pendiente.

Origen: https://github.com/jorgealmeidamontiel/terraform-laboratories/tree/main/segundo-programa
Commit base auditado: 9d0eb0eb0ec423248007a0df5e7031c29d138e8f.

La carpeta original contiene 14 videos y un archivo de comandos, sin archivos .tf.
Los videos 11–15 muestran un Resource Group y una red virtual en mexicocentral.
Esta configuración se reconstruyó mediante inspección de fotogramas de los videos.
No se afirma haber transcrito ni revisado todo el audio de los videos.

## Ajustes necesarios

- vnet_address_space se declara list(string), coherente con tfvars y address_space.
- tags utiliza un mapa vacío de valor predeterminado en lugar del string transitorio mostrado durante la edición.
- La suscripción se proporciona con ARM_SUBSCRIPTION_ID desde la sesión real, sin copiar la del profesor.
- Se deshabilita el registro automático de providers: comprobar Microsoft.Network explícitamente y registrar solo si es necesario.
- Se conserva la nomenclatura del ejemplo y se personaliza la etiqueta owner.
- No se añaden subredes, máquinas virtuales ni otros recursos que el ejemplo final no declara.

## Ejecución pendiente

```bash
az login --use-device-code
az account show --query '{user:user.name,subscription:name,id:id}' -o json
# Confirmar [CUENTA_INSTITUCIONAL_OCULTA] y la suscripción correcta antes de continuar.
export ARM_SUBSCRIPTION_ID="$(az account show --query id -o tsv)"
az provider show --namespace Microsoft.Network --subscription "$ARM_SUBSCRIPTION_ID" --query '{namespace:namespace,state:registrationState}' -o json
# Registrar solo si no está Registered y si se tienen permisos:
# az provider register --namespace Microsoft.Network --subscription "$ARM_SUBSCRIPTION_ID" --wait
terraform fmt -check
terraform init
terraform validate
terraform plan -var-file=practice.tfvars -out=practice.tfplan
# Revisar el plan real y confirmar cuenta, suscripción y recursos antes de apply:
terraform apply practice.tfplan
terraform output
```

No se ha ejecutado apply ni destroy. El plan real, los recursos, las capturas del despliegue y el Word final siguen pendientes.
GitHub está conectado como al222311440-source; falta resolver la diferencia con Felipe_sh007 antes de publicar.

## Validaciones ejecutadas

- Terraform 1.13.5; Azure CLI 2.91.0; Git 2.51.1.
- terraform fmt: correcto.
- terraform fmt -check -recursive: correcto.
- terraform init: correcto; AzureRM 5.9.0, firma HashiCorp y lock file generado.
- terraform validate: falló antes de comprobar la configuración. Diagnóstico del proveedor: listen unix /tmp/plugin…: socket: operation not permitted. Es una restricción de ejecución del entorno; no prueba que el código sea válido ni inválido.
- az account show: falló con Please run az login to setup account.
- terraform plan y apply: pendientes. No hay suscripción inventada ni recursos creados.
- Microsoft.Network: estado pendiente de consultar en la suscripción real.
- El Word final se generará después de obtener resultados y capturas reales.

Los logs incluidos son salidas textuales reales; no son capturas de pantalla. Los fotogramas auditados pertenecen a los videos del profesor y no se presentan como evidencias de una ejecución del alumno.
