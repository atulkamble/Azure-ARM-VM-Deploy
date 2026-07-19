<div align="center">
<h1>🚀 Azure VM Deployment using ARM (Step-by-Step)</h1>
<p><strong>Built with ❤️ by <a href="https://github.com/atulkamble">Atul Kamble</a></strong></p>

<p>
<a href="https://codespaces.new/atulkamble/template.git">
<img src="https://github.com/codespaces/badge.svg" alt="Open in GitHub Codespaces" />
</a>
<a href="https://vscode.dev/github/atulkamble/template">
<img src="https://img.shields.io/badge/Open%20with-VS%20Code-007ACC?logo=visualstudiocode&style=for-the-badge" alt="Open with VS Code" />
</a>
<a href="https://vscode.dev/redirect?url=vscode://ms-vscode-remote.remote-containers/cloneInVolume?url=https://github.com/atulkamble/template">
<img src="https://img.shields.io/badge/Dev%20Containers-Ready-blue?logo=docker&style=for-the-badge" />
</a>
<a href="https://desktop.github.com/">
<img src="https://img.shields.io/badge/GitHub-Desktop-6f42c1?logo=github&style=for-the-badge" />
</a>
</p>

<p>
<a href="https://github.com/atulkamble">
<img src="https://img.shields.io/badge/GitHub-atulkamble-181717?logo=github&style=flat-square" />
</a>
<a href="https://www.linkedin.com/in/atuljkamble/">
<img src="https://img.shields.io/badge/LinkedIn-atuljkamble-0A66C2?logo=linkedin&style=flat-square" />
</a>
<a href="https://x.com/atul_kamble">
<img src="https://img.shields.io/badge/X-@atul_kamble-000000?logo=x&style=flat-square" />
</a>
</p>

<strong>Version 1.0.0</strong> | <strong>Last Updated:</strong> July 2026
</div>

- **Repository:** `Azure-ARM-VM-Deploy`
- **Author:** Atul Kamble (Cloud Solutions Architect)
- **Platform:** Microsoft Azure
- **IaC Tool:** Azure ARM Templates
- **Audience:** Azure / DevOps Engineers, IaC Learners, Trainers

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
  --parameters vmName=myVM adminUsername=atul adminPassword=Password@123
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
