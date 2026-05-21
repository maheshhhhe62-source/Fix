FROM ubuntu:24.04

RUN apt-get update && apt-get install -y \
    gcc \
    g++ \
    python3 \
    python3-pip \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY . .

RUN gcc drx.c -o drx -pthread -O3 -s
RUN chmod +x drx
RUN pip3 install --no-cache-dir -r requirements.txt

EXPOSE 8080

CMD ["gunicorn", "--bind", "0.0.0.0:${PORT:-8080}", "app:app"]