```
git --version 
git clone https://github.com/atulkamble/Azure-ARM-VM-Deploy.git
cd Azure-ARM-VM-Deploy

choco install git
OR
brew install git 


az version 
az login 
Update VMSize if required to Line No. 112 


az group create --name MyResourceGroup --location eastus

az group list

az deployment group create --resource-group MyResourceGroup --template-file azuredeploy.json --parameters vmName=myVM adminUsername=atul adminPassword=Password@123

ssh atul@20.115.34.151
cat /etc/lsb-release
hostnamectl
uname -a

az deployment group delete -g testrg -n deployment01

az group delete --name MyResourceGroup 
```
