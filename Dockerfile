FROM ubuntu:24.04

# System dependencies
RUN apt-get update && apt-get install -y \
    gcc \
    python3 \
    python3-pip \
    python3-venv \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Copy all files
COPY . .

# Compile C Attack Tool
RUN gcc drx.c -o drx -pthread -O3 -s && chmod +x drx

# Setup Python Virtual Environment
RUN python3 -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"

# Install Flask & Gunicorn
RUN /opt/venv/bin/pip install --no-cache-dir flask gunicorn

EXPOSE 8080

# Final Start Command
CMD ["/opt/venv/bin/gunicorn", "--bind", "0.0.0.0:$PORT", "app:app"]