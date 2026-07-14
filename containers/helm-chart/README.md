# ToggleMaster Helm Chart

Este chart implanta todos os microsserviços do projeto ToggleMaster no Kubernetes/EKS.

## Serviços incluídos

- `auth-service`
- `flag-service`
- `targeting-service`
- `evaluation-service`
- `analytics-service`

## Como usar

1. Preencha os valores obrigatórios em `values.yaml`.
2. Ajuste os repositórios e tags de imagem para os seus componentes Docker.
3. Instale com Helm:

```bash
helm install togglemaster ./helm-chart --namespace togglemaster --create-namespace
```

## Configurações importantes

- `DATABASE_URL` deve apontar para o PostgreSQL usado por `auth-service`, `flag-service` e `targeting-service`.
- `AUTH_SERVICE_URL` deve apontar para o serviço interno `auth-service` no cluster.
- `REDIS_URL` deve apontar para um Redis acessível a partir do cluster.
- `AWS_SQS_URL`, `AWS_REGION` e `AWS_DYNAMODB_TABLE` são necessários para `analytics-service` e `evaluation-service`.

> Para EKS, prefira usar IAM Roles for Service Accounts (IRSA) em vez de colocar `AWS_ACCESS_KEY_ID`/`AWS_SECRET_ACCESS_KEY` diretamente em valores `env`.

## Observações

- Os serviços Python agora usam `gunicorn` no runtime para execução mais estável em Kubernetes.
- Todos os serviços expõem `/health` e usam probes de readiness/liveness.
