# Estágio 1: Build e Instalação
FROM python:3.12-alpine

WORKDIR /app

# Copia apenas o necessário para instalar as dependências primeiro
# (Isso ajuda no cache do Docker)
COPY requirements.txt .

# Instalando dependências e limpando o cache em um único comando
RUN pip install --no-cache-dir -r requirements.txt && \
    find /usr/local -depth \
        \( \
            \( -type d -a \( -name test -o -name tests -o -name idle_test \) \) \
            -o \
            \( -type f -a \( -name '*.pyc' -o -name '*.pyo' \) \) \
        \) -exec rm -rf '{}' +

# Copia o restante do código
COPY . .

EXPOSE 5000

CMD ["python", "app.py"]