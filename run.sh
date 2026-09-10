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

# 1. Prerequisites Auto-Installer Block
echo -e "${CYAN}🔍 Checking application engine prerequisites...${NC}"

if ! command -v docker &> /dev/null; then
    echo -e "${YELLOW}⚠️ Notice: Docker is not installed. Initiating automatic setup...${NC}"
    
    # Update localized apt lists and grab curl if it's missing from the host machine
    if command -v apt-get &> /dev/null; then
        echo -e "${CYAN}📦 Installing curl system packages...${NC}"
        sudo apt-get update -y && sudo apt-get install -y curl
        
        # Download and execute the official Docker convenience script natively
        echo -e "${CYAN}🐳 Downloading official Docker Engine installer...${NC}"
        curl -fsSL https://get.docker.com | sh
        
        # Ensure Docker service is fully active and enabled on boot
        sudo systemctl enable --now docker
        
        # Add the current non-root user to the docker security scope group
        sudo usermod -aG docker $USER
        
        echo -e "${GREEN}✅ Docker Engine and plugins successfully deployed!${NC}"
        echo -e "${YELLOW}⚠️ Note: You may need to refresh your shell session (run: 'newgrp docker') if permissions block non-sudo use.${NC}"
    else
        echo -e "${RED}❌ Error: Unsupported OS distribution package manager.${NC}"
        echo -e "${YELLOW}Please install Docker Engine manually via https://docker.com{NC}"
        exit 1
    fi
else
    echo -e "${GREEN}✅ Docker core binaries detected on the host system.${NC}"
fi

# Validate that the Compose plugin structure is also operational
if ! docker compose version &> /dev/null; then
    echo -e "${YELLOW}⚠️ Notice: Docker Compose CLI plugin missing. Attempting standalone resolution...${NC}"
    if command -v apt-get &> /dev/null; then
        sudo apt-get update -y && sudo apt-get install -y docker-compose-plugin
        echo -e "${GREEN}✅ Docker Compose plugin resolved!${NC}"
    else
        echo -e "${RED}❌ Error: Docker Compose missing. Install docker-compose-plugin before running.${NC}"
        exit 1
    fi
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
# Use sudo fallback gracefully if user group configurations haven't reloaded yet
if docker compose down --remove-orphans 2>/dev/null; then
    docker compose down --remove-orphans
else
    sudo docker compose down --remove-orphans
fi

# 4. Compilation & Deployment
echo -e "${CYAN}⚙️ Building container layers and establishing network scopes...${NC}"
if docker compose up -d --build; then
    docker compose up -d --build
else
    sudo docker compose up -d --build
fi

echo -e "${CYAN}==================================================${NC}"
echo -e "${GREEN}🎉 Success! Your container deployment is live!${NC}"
echo -e "${CYAN}🌐 Application Interface URL: ${YELLOW}http://localhost:8000${NC}"
echo -e "${CYAN}📁 Track real-time runtime engine logs with: ${YELLOW}docker compose logs -f${NC}"
echo -e "${CYAN}==================================================${NC}"
