![Image](https://ravichaganti.com/images/armin30/templatearchitecture.png)

![Image](https://learn.microsoft.com/en-us/azure/azure-resource-manager/templates/media/template-tutorial-create-templates-with-dependent-resources/resource-manager-template-dependent-resources-diagram.png)

![Image](https://learn.microsoft.com/en-us/azure/azure-resource-manager/management/media/overview/consistent-management-layer.png)

# 🟦 Azure ARM VM Deployment – Complete Documentation

**Repository:** `Azure-ARM-VM-Deploy`
**Author:** Atul Kamble (Cloud Solutions Architect)
**Platform:** Microsoft Azure
**IaC Tool:** Azure ARM Templates
**Audience:** Azure / DevOps Engineers, IaC Learners, Trainers

---

## 📌 Project Overview

This project demonstrates **Infrastructure as Code (IaC)** using **Azure ARM Templates** to deploy a **Linux Virtual Machine** along with:

* Resource Group
* Virtual Network & Subnet
* Public IP
* Network Interface
* Ubuntu Linux VM

Deployment can be done using:

* ✅ Automated **Shell Script**
* ✅ Manual **Azure CLI commands**

---

## 🧰 Prerequisites

Before starting, ensure:

* Azure Subscription (Contributor access)
* Azure CLI installed
* Logged in via `az login`
* Git installed
* Bash shell (Linux/macOS/WSL)

---

## 📥 Step 1: Clone the Repository

```bash
git clone https://github.com/atulkamble/Azure-ARM-VM-Deploy.git
cd Azure-ARM-VM-Deploy
```

📂 **Repository Contents**

```
Azure-ARM-VM-Deploy/
├── azuredeploy.json
├── azuredeploy.parameters.json
├── deploy.sh
└── README.md
```

---

## 🚀 Step 2: Deployment Options

---

## 🔹 Option A: Automated Deployment (Recommended)

### Make script executable

```bash
chmod +x deploy.sh
```

### Run deployment

```bash
./deploy.sh
```

### What `deploy.sh` does:

1. Creates Resource Group
2. Deploys ARM template
3. Passes VM parameters
4. Displays output (Public IP)

✔️ Best for **CI/CD pipelines & training demos**

---

## 🔹 Option B: Manual Azure CLI Deployment

### 1️⃣ Create Resource Group

```bash
az group create \
  --name MyResourceGroup \
  --location eastus
```

---

### 2️⃣ Deploy ARM Template

```bash
az deployment group create \
  --resource-group MyResourceGroup \
  --template-file azuredeploy.json \
  --parameters vmName=myVM adminUsername=atul adminPassword=Ethans@123
```

📌 **Parameters Explained**

| Parameter     | Description                             |
| ------------- | --------------------------------------- |
| vmName        | Name of the Virtual Machine             |
| adminUsername | Linux admin user                        |
| adminPassword | Secure password (use Key Vault in prod) |

---

### 3️⃣ (Optional) Delete Resource Group

```bash
az group delete \
  --name MyResourceGroup \
  --yes \
  --no-wait
```

⚠️ Deletes **ALL** resources in the group

---

# 🟦 Azure ARM Templates – Cheatsheet & Codes

---

## 📘 1. ARM Template Basics

### ARM Template Structure

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {},
  "variables": {},
  "resources": [],
  "outputs": {}
}
```

---

## 🧩 2. Parameters Section

### Basic Parameter

```json
"adminUsername": {
  "type": "string",
  "defaultValue": "cloudnautic"
}
```

### Secure Password

```json
"adminPassword": {
  "type": "secureString"
}
```

### Allowed Values

```json
"vmSize": {
  "type": "string",
  "allowedValues": [
    "Standard_B1s",
    "Standard_B2s",
    "Standard_D2s_v3"
  ],
  "defaultValue": "Standard_B1s"
}
```

---

## ♻️ 3. Variables Section

```json
"variables": {
  "location": "[resourceGroup().location]",
  "nicName": "[concat(parameters('vmName'), '-nic')]",
  "publicIpName": "[concat(parameters('vmName'), '-pip')]"
}
```

---

## 🏗 4. Common ARM Resources

### 4.1 Virtual Network

```json
{
  "type": "Microsoft.Network/virtualNetworks",
  "apiVersion": "2023-04-01",
  "name": "[parameters('vnetName')]",
  "location": "[variables('location')]",
  "properties": {
    "addressSpace": {
      "addressPrefixes": ["10.0.0.0/16"]
    },
    "subnets": [
      {
        "name": "subnetA",
        "properties": {
          "addressPrefix": "10.0.1.0/24"
        }
      }
    ]
  }
}
```

---

### 4.2 Public IP

```json
{
  "type": "Microsoft.Network/publicIPAddresses",
  "apiVersion": "2023-04-01",
  "name": "[variables('publicIpName')]",
  "location": "[variables('location')]",
  "properties": {
    "publicIPAllocationMethod": "Dynamic"
  }
}
```

---

### 4.3 Network Interface

```json
{
  "type": "Microsoft.Network/networkInterfaces",
  "apiVersion": "2023-04-01",
  "name": "[variables('nicName')]",
  "location": "[variables('location')]",
  "properties": {
    "ipConfigurations": [
      {
        "name": "ipconfig1",
        "properties": {
          "subnet": {
            "id": "[resourceId('Microsoft.Network/virtualNetworks/subnets', parameters('vnetName'), 'subnetA')]"
          },
          "publicIPAddress": {
            "id": "[resourceId('Microsoft.Network/publicIPAddresses', variables('publicIpName'))]"
          }
        }
      }
    ]
  }
}
```

---

### 4.4 Linux Virtual Machine

```json
{
  "type": "Microsoft.Compute/virtualMachines",
  "apiVersion": "2023-03-01",
  "name": "[parameters('vmName')]",
  "location": "[variables('location')]",
  "dependsOn": [
    "[resourceId('Microsoft.Network/networkInterfaces', variables('nicName'))]"
  ],
  "properties": {
    "hardwareProfile": {
      "vmSize": "[parameters('vmSize')]"
    },
    "osProfile": {
      "computerName": "[parameters('vmName')]",
      "adminUsername": "[parameters('adminUsername')]",
      "adminPassword": "[parameters('adminPassword')]"
    },
    "storageProfile": {
      "imageReference": {
        "publisher": "Canonical",
        "offer": "UbuntuServer",
        "sku": "18.04-LTS",
        "version": "latest"
      }
    },
    "networkProfile": {
      "networkInterfaces": [
        {
          "id": "[resourceId('Microsoft.Network/networkInterfaces', variables('nicName'))]"
        }
      ]
    }
  }
}
```

---

## 📤 5. Outputs

```json
"outputs": {
  "publicIP": {
    "type": "string",
    "value": "[reference(variables('publicIpName')).ipAddress]"
  }
}
```

---

## 🧪 6. Test Deployment (What-If)

```bash
az deployment group what-if \
  --resource-group MyResourceGroup \
  --template-file azuredeploy.json \
  --parameters @azuredeploy.parameters.json
```

---

## 📂 7. Recommended Folder Structure

```
arm/
├── main.json
├── azuredeploy.json
├── azuredeploy.parameters.json
├── templates/
│   ├── vnet.json
│   ├── vm.json
│   └── nsg.json
└── scripts/
    └── deploy.sh
```

---

## 🏁 Final Notes

✅ Use **Key Vault** for passwords in production
✅ Prefer **Incremental mode** deployments
✅ ARM is ideal for **Azure-native IaC**
✅ For multi-cloud → consider Terraform/Bicep

---
