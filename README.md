```
git clone https://github.com/atulkamble/Azure-ARM-VM-Deploy.git
cd Azure-ARM-VM-Deploy
```
// on terminal 
```
chmod +x deploy.sh
./deploy.sh
```
or 
```
az group create --name MyResourceGroup --location eastus
az deployment group create --resource-group MyResourceGroup --template-file azuredeploy.json --parameters vmName=myVM adminUsername=atul adminPassword=Ethans@123
az group delete --name MyResourceGroup --yes --no-wait
```
---

# 🟦 **Azure ARM Templates – Cheatsheet & Codes**

**Author:** Atul Kamble (Cloud Solutions Architect)
**Use Cases:** Azure DevOps, IaC, Automation, Training, Projects

---

# 📘 **1. ARM Template Basics**

### ✅ **ARM Template Structure**

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

# 🧩 **2. Parameters Section Examples**

### 🟦 **Basic Parameter**

```json
"adminUsername": {
  "type": "string",
  "defaultValue": "cloudnautic"
}
```

### 🔐 **Secure Password**

```json
"adminPassword": {
  "type": "secureString"
}
```

### 🗂 **Allowed Values**

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

# ♻️ **3. Variables Section**

```json
"variables": {
  "location": "[resourceGroup().location]",
  "nicName": "[concat(parameters('vmName'), '-nic')]",
  "publicIpName": "[concat(parameters('vmName'), '-pip')]"
}
```

---

# 🏗 **4. Common ARM Resource Templates**

---

## 🌐 **4.1 Resource Group Deployment Command**

```bash
az group create --name myrg --location eastus
az deployment group create \
  --resource-group myrg \
  --template-file azuredeploy.json \
  --parameters @azuredeploy.parameters.json
```

---

## 🖧 **4.2 Virtual Network**

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

## 🌐 **4.3 Public IP**

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

## 🧷 **4.4 Network Interface**

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

## 💻 **4.5 Linux Virtual Machine**

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

# 📤 **5. Outputs Example**

```json
"outputs": {
  "publicIP": {
    "type": "string",
    "value": "[reference(variables('publicIpName')).ipAddress]"
  }
}
```

---

# 🛠 **6. ARM Template Deployment Commands**

### 🟦 **Group Deployment**

```bash
az deployment group create \
--resource-group myrg \
--template-file azuredeploy.json \
--parameters vmName=myvm adminUsername=atul adminPassword=Ethans@123
```

### 🟩 **Subscription Deployment**

```bash
az deployment sub create \
--location eastus \
--template-file main.json
```

---

# 🔁 **7. Linked Templates (Nested ARM)**

### **Main Template**

```json
{
  "type": "Microsoft.Resources/deployments",
  "apiVersion": "2020-06-01",
  "name": "linkedTemplate",
  "properties": {
    "mode": "Incremental",
    "templateLink": {
      "uri": "https://raw.githubusercontent.com/atulkamble/.../vnet.json"
    }
  }
}
```

---

# 🪄 **8. ARM Functions Quick Reference**

| Function       | Example                                   | Description         |
| -------------- | ----------------------------------------- | ------------------- |
| `concat()`     | concat('vm','01')                         | Join strings        |
| `resourceId()` | resourceId('Microsoft.Network/vnet','v1') | Get resource ID     |
| `reference()`  | reference('mypip').ipAddress              | Fetch runtime value |
| `variables()`  | variables('location')                     | Access variables    |
| `parameters()` | parameters('vmSize')                      | Access parameters   |

---

# 🧪 **9. Testing ARM Template**

```bash
az deployment group what-if \
  --resource-group myrg \
  --template-file azuredeploy.json \
  --parameters @azuredeploy.parameters.json
```

---

# 📂 **10. Recommended ARM Template Folder Structure**

```
arm/
 ├── main.json
 ├── azuredeploy.json
 ├── azuredeploy.parameters.json
 ├── templates/
 │    ├── vnet.json
 │    ├── vm.json
 │    ├── nsg.json
 └── scripts/
      └── deploy.sh
```

---
