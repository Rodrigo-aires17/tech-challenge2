
# Multi-stage Dockerfile otimizado para EKS
# - usuário não-root
# - instala gunicorn e dependências no build stage
# - copia o prefixo /install para a imagem final

FROM python:3.11-slim AS builder

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PIP_NO_CACHE_DIR=off

WORKDIR /app

RUN apt-get update \
    && apt-get install -y --no-install-recommends build-essential libpq-dev gcc ca-certificates \
    && rm -rf /var/lib/apt/lists/*

COPY requirements.txt ./

RUN python -m pip install --upgrade pip setuptools wheel \
    && python -m pip install --prefix=/install -r requirements.txt gunicorn

FROM python:3.11-slim

ENV PATH="/install/bin:$PATH" \
    PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    HOME=/app

WORKDIR /app

RUN apt-get update \
    && apt-get install -y --no-install-recommends libpq5 ca-certificates wget \
    && rm -rf /var/lib/apt/lists/*

COPY --from=builder /install /usr/local
COPY . /app

RUN addgroup --system app \
    && adduser --system --ingroup app --home /app app \
    && chown -R app:app /app

USER app

EXPOSE 8003

HEALTHCHECK --interval=30s --timeout=5s --start-period=15s --retries=3 \
  CMD wget -qO- --timeout=5 --tries=1 http://127.0.0.1:8003/health || exit 1

CMD ["gunicorn", "--bind", "0.0.0.0:8003", "app:app", "--workers", "1"]
