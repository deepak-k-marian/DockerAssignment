# ==========================================
# 1. Base Build & OS Preparation
# ==========================================
FROM python:3.11-alpine

# Set system configurations for python isolation
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# Establish a secure operating directory
WORKDIR /workspace

# Install temporary build essentials for wheel compilation, then clean up
RUN apk add --no-cache --virtual .build-deps gcc musl-dev libffi-dev \
    && pip install --no-cache-dir --upgrade pip setuptools wheel

# ==========================================
# 2. Dependency Resolution
# ==========================================
# Copy the minimal requirements configuration sheet
COPY requirements.txt .

# Install dependencies cleanly and purge the compiler layer to minimize size
RUN pip install --no-cache-dir -r requirements.txt \
    && apk del .build-deps

# ==========================================
# 3. Source Assembly & Security Hardening
# ==========================================
# Copy the structural core source files inside the container working directory
COPY app/ ./app/

# Create a non-privileged custom runtime user for security compliance
RUN adduser -D appuser \
    && chown -R appuser:appuser /workspace
USER appuser

# Switch the working directory into the app package so relative
# paths (static/templates) in main.py resolve correctly at runtime
WORKDIR /workspace/app

# Expose the target network access interface port
EXPOSE 8000

# ==========================================
# 4. Process Launch
# ==========================================
# Execute the production uvicorn service bound to all available network host systems
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]
