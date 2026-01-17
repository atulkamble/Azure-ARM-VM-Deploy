#!/bin/bash

# Azure Resource Cleanup Script
# Author: Atul Kamble
# Description: Deletes the resource group and all resources created by the deployment

set -e  # Exit on error

# Configuration (must match deploy.sh)
RESOURCE_GROUP="MyResourceGroup"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${RED}=== Azure Resource Cleanup Script ===${NC}"
echo ""

# Check if Azure CLI is installed
if ! command -v az &> /dev/null; then
    echo -e "${RED}Error: Azure CLI is not installed.${NC}"
    exit 1
fi

# Check if logged in to Azure
echo -e "${YELLOW}Checking Azure login status...${NC}"
if ! az account show &> /dev/null; then
    echo -e "${RED}Not logged in. Please log in to Azure...${NC}"
    az login
fi

# Display current subscription
SUBSCRIPTION=$(az account show --query name -o tsv)
echo -e "${GREEN}Using subscription: ${SUBSCRIPTION}${NC}"
echo ""

# Check if resource group exists
echo -e "${YELLOW}Checking if resource group exists...${NC}"
if ! az group exists --name "$RESOURCE_GROUP" --output tsv | grep -q "true"; then
    echo -e "${YELLOW}Resource group '$RESOURCE_GROUP' does not exist.${NC}"
    echo -e "${GREEN}Nothing to clean up!${NC}"
    exit 0
fi

# List resources in the group
echo -e "${YELLOW}Resources in '$RESOURCE_GROUP':${NC}"
az resource list --resource-group "$RESOURCE_GROUP" --query "[].{Name:name, Type:type}" -o table
echo ""

# Confirmation prompt
echo -e "${RED}WARNING: This will DELETE the resource group '$RESOURCE_GROUP' and ALL its resources!${NC}"
read -p "Are you sure you want to continue? (yes/no): " CONFIRM

if [[ "$CONFIRM" != "yes" ]]; then
    echo -e "${YELLOW}Cleanup cancelled.${NC}"
    exit 0
fi

echo ""
echo -e "${YELLOW}Deleting resource group: $RESOURCE_GROUP...${NC}"
echo -e "${YELLOW}This may take 2-5 minutes...${NC}"
echo ""

# Delete resource group
if az group delete --name "$RESOURCE_GROUP" --yes --no-wait; then
    echo -e "${GREEN}✓ Deletion initiated successfully!${NC}"
    echo ""
    echo -e "${YELLOW}The resource group is being deleted in the background.${NC}"
    echo -e "${YELLOW}To check deletion status, run:${NC}"
    echo -e "${GREEN}az group show --name $RESOURCE_GROUP${NC}"
    echo ""
    
    # Wait for deletion to complete (optional)
    read -p "Wait for deletion to complete? (yes/no): " WAIT
    if [[ "$WAIT" == "yes" ]]; then
        echo -e "${YELLOW}Waiting for deletion to complete...${NC}"
        while az group exists --name "$RESOURCE_GROUP" --output tsv | grep -q "true"; do
            echo -n "."
            sleep 5
        done
        echo ""
        echo -e "${GREEN}✓ Resource group deleted successfully!${NC}"
    fi
else
    echo -e "${RED}Failed to delete resource group!${NC}"
    exit 1
fi

echo ""
echo -e "${GREEN}=== Cleanup Complete! ===${NC}"
