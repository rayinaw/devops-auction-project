$ACR_NAME=arcade
$RESOURCE_GROUP=myRancherGroup
$CLUSTER_NAME=
az login
# Create ACR
az acr create -n $ACR_NAME -g $RESOURCE_GROUP --sku basic
# Attach ACR
az aks update -n $CLUSTER_NAME -g $RESOURCE_GROUP --attach-acr $ACR_NAME