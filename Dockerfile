FROM ubuntu:24.04

RUN apt-get update && apt-get install -y \
    gcc \
    python3 \
    python3-pip \
    python3-dev \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY . .

# Compile C binary
RUN gcc drx.c -o drx -pthread -O3 -s && chmod +x drx

# Install Python deps
RUN pip3 install --no-cache-dir flask gunicorn

EXPOSE 8080

CMD ["gunicorn", "--bind", "0.0.0.0:$PORT", "app:app"]