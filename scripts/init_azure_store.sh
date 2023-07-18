
# see https://learn.microsoft.com/en-us/azure/container-instances/container-instances-volume-azure-files

# Change these four parameters as needed
ACI_PERS_RESOURCE_GROUP=DocVerPoC_group
ACI_PERS_STORAGE_ACCOUNT_NAME=reppocstorageaccount2
ACI_PERS_LOCATION=eastus2
ACI_PERS_SHARE_NAME=acishare

# Create the storage account with the parameters
az storage account create \
    --resource-group $ACI_PERS_RESOURCE_GROUP \
    --name $ACI_PERS_STORAGE_ACCOUNT_NAME \
    --location $ACI_PERS_LOCATION \
    --sku Standard_LRS

# Create the file share
az storage share create \
  --name $ACI_PERS_SHARE_NAME \
  --account-name $ACI_PERS_STORAGE_ACCOUNT_NAME

# Creeate storage key
STORAGE_KEY=$(az storage account keys list --resource-group $ACI_PERS_RESOURCE_GROUP --account-name $ACI_PERS_STORAGE_ACCOUNT_NAME --query "[0].value" --output tsv)
echo $STORAGE_KEY

# Create file container
az container create \
    --resource-group $ACI_PERS_RESOURCE_GROUP \
    --name reppocstorecontainer \
    --image mcr.microsoft.com/azuredocs/aci-hellofiles \
    --dns-name-label rep-poc-demo \
    --ports 80 \
    --azure-file-volume-account-name $ACI_PERS_STORAGE_ACCOUNT_NAME \
    --azure-file-volume-account-key $STORAGE_KEY \
    --azure-file-volume-share-name $ACI_PERS_SHARE_NAME \
    --azure-file-volume-mount-path /aci/data

az container show --resource-group $ACI_PERS_RESOURCE_GROUP \
  --name reppocstorecontainer --query ipAddress.fqdn --output tsv