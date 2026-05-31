[https://github.com/atulkamble/Azure-ARM-VM-Deploy
choco install git                           brew install git 

git --version 
az version 
az login 
Update VMSize if required to Line No. 112 

git clone https://github.com/atulkamble/Azure-ARM-VM-Deploy.git
cd Azure-ARM-VM-Deploy

az group create --name MyResourceGroup --location eastus

az deployment group create --resource-group MyResourceGroup --template-file azuredeploy.json --parameters vmName=myVM adminUsername=atul adminPassword=Password@123

ssh atul@20.115.34.151
cat /etc/lsb-release
](https://github.com/atulkamble/Azure-ARM-VM-Deploy
choco install git                           brew install git 

git --version 
az version 
az login 
Update VMSize if required to Line No. 112 

git clone https://github.com/atulkamble/Azure-ARM-VM-Deploy.git
cd Azure-ARM-VM-Deploy

az group create --name MyResourceGroup --location eastus

az deployment group create --resource-group MyResourceGroup --template-file azuredeploy.json --parameters vmName=myVM adminUsername=atul adminPassword=Password@123

ssh atul@20.115.34.151
cat /etc/lsb-release

az deployment group delete -g testrg -n deployment01

az group delete --name MyResourceGroup 
)
