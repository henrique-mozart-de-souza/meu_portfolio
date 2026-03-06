FROM python:3.12-alpine

WORKDIR /app

# 1. Copia apenas o arquivo de dependências primeiro
COPY requirements.txt .

# 2. Instala, limpa o cache do pip e remove arquivos desnecessários 
# TUDO EM UMA ÚNICA CAMADA (RUN)
RUN pip install --no-cache-dir -r requirements.txt && \
    find /usr/local -depth \
        \( \
            \( -type d -a \( -name test -o -name tests -o -name idle_test \) \) \
            -o \
            \( -type f -a \( -name '*.pyc' -o -name '*.pyo' \) \) \
        \) -exec rm -rf '{}' +

# 3. Copia o seu código (Certifique-se que o .dockerignore está correto!)
COPY . .

# 4. Variáveis de ambiente para performance
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

EXPOSE 5000

CMD ["python", "app.py"]