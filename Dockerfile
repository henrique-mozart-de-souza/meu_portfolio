# 1. Escolha de Imagem Base Leve e Estável
FROM python:3.12-alpine

# 2. Configurações de Ambiente (Boas Práticas Python)
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    FLASK_ENV=production

WORKDIR /app

# 3. Segurança: Criar usuário sem privilégios antes de copiar os arquivos
RUN addgroup -S appgroup && adduser -S appuser -G appgroup

# 4. Instalação de Dependências (Camada Otimizada)
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt && \
    find /usr/local -depth \
        \( \
            \( -type d -a \( -name test -o -name tests -o -name idle_test \) \) \
            -o \
            \( -type f -a \( -name '*.pyc' -o -name '*.pyo' \) \) \
        \) -exec rm -rf '{}' +

# 5. Cópia do Código Fonte
COPY . .

# 6. Ajuste de Permissões (Hardening)
# Garante que o usuário restrito seja dono apenas do que precisa
RUN chown -R appuser:appgroup /app

# 7. Definição do Usuário de Execução
USER appuser

# 8. Porta de Exposição
EXPOSE 5000

# 9. Comando de Inicialização (Gunicorn para Produção)
# Usamos o Gunicorn para gerenciar workers, muito mais robusto que o 'python app.py'
CMD ["gunicorn", "--workers", "2", "--bind", "0.0.0.0:5000", "app:app"]