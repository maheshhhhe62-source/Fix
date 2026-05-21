FROM ubuntu:24.04

# Avoid interactive prompts
ENV DEBIAN_FRONTEND=noninteractive

# Install required packages
RUN apt-get update && apt-get install -y \
    gcc \
    python3 \
    python3-pip \
    python3-venv \
    && rm -rf /var/lib/apt/lists/*

# App directory
WORKDIR /app

# Copy all project files
COPY . .

# Compile drx.c
RUN gcc drx.c -o drx -pthread -O3 -s && chmod +x drx

# Create virtual environment
RUN python3 -m venv /opt/venv

# Add venv to PATH
ENV PATH="/opt/venv/bin:$PATH"

# Install Python packages
RUN pip install --no-cache-dir flask gunicorn

# Render uses dynamic PORT
EXPOSE 8080

# Start Gunicorn correctly with PORT variable
CMD ["sh", "-c", "gunicorn --bind 0.0.0.0:$PORT --workers 1 app:app"]