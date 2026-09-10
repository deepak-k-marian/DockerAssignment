# 🚀 Docker FastAPI Automated Email Application

A containerized, single-page application built on FastAPI that collects user email addresses and schedules asynchronous delivery workflows via Gmail SMTP relays using Python background workers.

---

## 🛠️ Prerequisites
Ensure you have the following software infrastructure operational on your environment:
* **Docker Desktop** (or Docker Engine with Docker Compose enabled)
* **Git** client utilities

---

## 🏎️ Quick Start (Automated Script Execution)

To download, configure, build, and deploy this entire stack with a single command interaction string, open your system terminal and execute the following sequence:

```bash
# 1. Clone the project repository framework from source systems
git clone <github-url-of-this-repo-here>
cd DockerAssignment

# 2. Grant permissions and execute the master automation controller script
chmod +x run.sh
./run.sh
```

The script will automatically detect your local Docker settings engine, walk you through safe configuration questions to create your secret `.env` file, wipe away previous workspace state caches, compile the clean Alpine image profile layers, and host the web dashboard live on your system!

---

## 🌐 Manual Step-by-Step Alternative

If you prefer to bypass the configuration helper script and handle deployment manually, use this baseline approach:

### 1. Configure Environment Secrets
Duplicate the blueprint file structure and add your specific Google authentication strings:
```bash
cp .env.example .env
```
Open the newly created `.env` file and insert your active Gmail profile parameters:
```text
SENDER_EMAIL=youractualgmail@gmail.com
SENDER_PASSWORD=your16digitapppassword
```

### 2. Boot Application Services
Compile the container configuration assets and map host system networking targets in background daemon execution profiles:
```bash
docker compose up -d --build
```

---

## 📋 System State Management & Inspection Reference

Keep these standard utility commands handy to check the status of your running container application:

* **Inspect live server stdout streams:**
  ```bash
  docker compose logs -f
  ```
* **Verify active background network run states:**
  ```bash
  docker compose ps
  ```
* **Terminate and tear down active container instances:**
  ```bash
  docker compose down
  ```
