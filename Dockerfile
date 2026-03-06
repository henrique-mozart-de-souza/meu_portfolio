# ETAPA 1: Builder (Compila as dependências)
FROM python:3.12-alpine AS builder

WORKDIR /app
COPY requirements.txt .

# Cria os pacotes (wheels) para não precisar compilar no runtime
RUN pip wheel --no-cache-dir --no-deps --wheel-dir /app/wheels -r requirements.txt


# ETAPA 2: Runtime (Imagem final super leve e segura)
FROM python:3.12-alpine

# Segurança: Cria um grupo e um usuário sem privilégios de root
RUN addgroup -S appgroup && adduser -S appuser -G appgroup

WORKDIR /app

# Copia os pacotes compilados da etapa anterior e instala
COPY --from=builder /app/wheels /wheels
COPY --from=builder /app/requirements.txt .
RUN pip install --no-cache /wheels/*

# Copia o código fonte do projeto
COPY . .

# Segurança: Muda a propriedade dos arquivos para o novo usuário
RUN chown -R appuser:appgroup /app

# Segurança: Define o usuário restrito para rodar a aplicação daqui em diante
USER appuser

# Expõe a porta que o Gunicorn vai usar
EXPOSE 5000

# Inicia o servidor web Gunicorn
CMD ["gunicorn", "-w", "2", "-b", "0.0.0.0:5000", "app:app"]