#!/bin/bash

# Force script to exit immediately if any single command fails
set -e

# Visual formatting configurations
GREEN='\033[0;32m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${CYAN}==================================================${NC}"
echo -e "${CYAN}🚀 Automated Setup: FastAPI Email Container App 🚀${NC}"
echo -e "${CYAN}==================================================${NC}"

# 1. Dependency Validation Check
if ! command -v docker &> /dev/null; then
    echo -e "${RED}❌ Error: Docker is not installed on this system.${NC}"
    echo -e "${YELLOW}Please install Docker and try running this script again.${NC}"
    exit 1
fi

# 2. Environment Configuration Check
if [ ! -f .env ]; then
    echo -e "${YELLOW}⚠️ Notice: No existing .env file found. Setting up from .env.example...${NC}"
    
    if [ ! -f .env.example ]; then
        echo -e "${RED}❌ Error: Missing configuration blueprint (.env.example).${NC}"
        exit 1
    fi

    # Read secure credential parameters directly from standard terminal input streams
    echo -e "${CYAN}📝 Configuration wizard setup:${NC}"
    read -p "👉 Enter your sender Gmail address: " user_email
    read -sp "👉 Enter your 16-character Google App Password: " user_pass
    echo "" # Add clear newline padding

    # Populate and export configurations directly onto the target hidden environment variable file
    cp .env.example .env
    sed -i "s|SENDER_EMAIL=.*|SENDER_EMAIL=$user_email|g" .env
    sed -i "s|SENDER_PASSWORD=.*|SENDER_PASSWORD=$user_pass|g" .env
    
    echo -e "${GREEN}✅ Successfully generated a localized secure .env profile configuration.${NC}"
else
    echo -e "${GREEN}ℹ️ Existing .env settings detected. Skipping baseline onboarding prompts.${NC}"
fi

# 3. Cache & Lifecycle Process Maintenance Cleanup
echo -e "${CYAN}🧹 Sweeping workspace environment states...${NC}"
docker compose down --remove-orphans 2>/dev/null || true

# 4. Compilation & Deployment
echo -e "${CYAN}⚙️ Building container layers and establishing network scopes...${NC}"
docker compose up -d --build

echo -e "${CYAN}==================================================${NC}"
echo -e "${GREEN}🎉 Success! Your container deployment is live!${NC}"
echo -e "${CYAN}🌐 Application Interface URL: ${YELLOW}http://localhost:8000${NC}"
echo -e "${CYAN}📁 Track real-time runtime engine logs with: ${YELLOW}docker compose logs -f${NC}"
echo -e "${CYAN}==================================================${NC}"
