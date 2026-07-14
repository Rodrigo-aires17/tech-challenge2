# Multi-stage Dockerfile otimizado para EKS
# - usuário não-root
# - imagem mais enxuta
# - inclui bibliotecas libpq em tempo de execução
# - configura HOME para não causar erro de permissão do gunicorn

FROM python:3.11-slim AS builder

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PIP_NO_CACHE_DIR=off

WORKDIR /app

RUN apt-get update \
    && apt-get install -y --no-install-recommends build-essential libpq-dev gcc ca-certificates \
    && rm -rf /var/lib/apt/lists/*

COPY requirements.txt ./

RUN python -m pip install --upgrade pip setuptools \
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

EXPOSE 8002

HEALTHCHECK --interval=15s --timeout=2s --start-period=10s --retries=3 \
  CMD wget -qO- --timeout=2 --tries=1 http://127.0.0.1:8002/health || exit 1

CMD ["gunicorn", "-w", "4", "-b", "0.0.0.0:8002", "app:app", "--timeout", "30"]
