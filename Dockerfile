FROM ubuntu:24.04

RUN apt-get update && apt-get install -y \
    gcc \
    python3 \
    python3-pip \
    python3-venv \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY . .

# Compile
RUN gcc drx.c -o drx -pthread -O3 -s && chmod +x drx

# Python venv
RUN python3 -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"

RUN /opt/venv/bin/pip install --no-cache-dir flask gunicorn

EXPOSE 8080

CMD ["sh", "-c", "/opt/venv/bin/gunicorn --bind 0.0.0.0:${PORT:-8080} --workers 1 app:app"]