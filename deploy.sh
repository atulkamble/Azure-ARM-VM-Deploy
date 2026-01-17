#!/bin/bash

# Azure ARM Template VM Deployment Script
# Author: Atul Kamble
# Description: Deploys a Linux VM using ARM template with proper error handling

set -e  # Exit on error

# Configuration
RESOURCE_GROUP="MyResourceGroup"
LOCATION="eastus"
VM_NAME="myVM"
ADMIN_USERNAME="atul"
TEMPLATE_FILE="azuredeploy.json"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}=== Azure VM Deployment using ARM Template ===${NC}"
echo ""

# Check if Azure CLI is installed
if ! command -v az &> /dev/null; then
    echo -e "${RED}Error: Azure CLI is not installed. Please install it first.${NC}"
    echo "Visit: https://learn.microsoft.com/cli/azure/install-azure-cli"
    exit 1
fi

# Check if logged in to Azure
echo -e "${YELLOW}Checking Azure login status...${NC}"
if ! az account show &> /dev/null; then
    echo -e "${YELLOW}Not logged in. Please log in to Azure...${NC}"
    az login
fi

# Display current subscription
SUBSCRIPTION=$(az account show --query name -o tsv)
echo -e "${GREEN}Using subscription: ${SUBSCRIPTION}${NC}"
echo ""

# Check if template file exists
if [ ! -f "$TEMPLATE_FILE" ]; then
    echo -e "${RED}Error: Template file $TEMPLATE_FILE not found!${NC}"
    exit 1
fi

# Validate the ARM template
echo -e "${YELLOW}Validating ARM template...${NC}"
if az deployment group validate \
    --resource-group "$RESOURCE_GROUP" \
    --template-file "$TEMPLATE_FILE" \
    --parameters vmName="$VM_NAME" adminUsername="$ADMIN_USERNAME" adminPassword='Ethans@123' \
    --only-show-errors 2>/dev/null; then
    echo -e "${GREEN}✓ Template validation successful${NC}"
else
    echo -e "${YELLOW}Note: Resource group doesn't exist yet, will create it${NC}"
fi
echo ""

# Create Resource Group
echo -e "${YELLOW}Creating resource group: $RESOURCE_GROUP in $LOCATION...${NC}"
if az group create --name "$RESOURCE_GROUP" --location "$LOCATION" --output none; then
    echo -e "${GREEN}✓ Resource group created successfully${NC}"
else
    echo -e "${RED}Error creating resource group${NC}"
    exit 1
fi
echo ""

# Deploy ARM Template
echo -e "${YELLOW}Deploying VM using ARM template...${NC}"
echo -e "${YELLOW}This may take 5-10 minutes...${NC}"
echo ""

DEPLOYMENT_NAME="vm-deployment-$(date +%s)"

if az deployment group create \
    --name "$DEPLOYMENT_NAME" \
    --resource-group "$RESOURCE_GROUP" \
    --template-file "$TEMPLATE_FILE" \
    --parameters vmName="$VM_NAME" adminUsername="$ADMIN_USERNAME" adminPassword='Ethans@123' \
    --output table; then
    echo ""
    echo -e "${GREEN}✓ Deployment completed successfully!${NC}"
else
    echo -e "${RED}Deployment failed!${NC}"
    exit 1
fi
echo ""

# Get VM details
echo -e "${YELLOW}Retrieving VM details...${NC}"
PUBLIC_IP=$(az network public-ip show \
    --resource-group "$RESOURCE_GROUP" \
    --name "${VM_NAME}-ip" \
    --query ipAddress -o tsv)

echo ""
echo -e "${GREEN}=== Deployment Summary ===${NC}"
echo -e "Resource Group: ${GREEN}$RESOURCE_GROUP${NC}"
echo -e "Location: ${GREEN}$LOCATION${NC}"
echo -e "VM Name: ${GREEN}$VM_NAME${NC}"
echo -e "Public IP: ${GREEN}$PUBLIC_IP${NC}"
echo -e "SSH Username: ${GREEN}$ADMIN_USERNAME${NC}"
echo ""
echo -e "${GREEN}Connect to your VM using:${NC}"
echo -e "${YELLOW}ssh $ADMIN_USERNAME@$PUBLIC_IP${NC}"
echo ""
echo -e "${GREEN}=== Deployment Complete! ===${NC}"