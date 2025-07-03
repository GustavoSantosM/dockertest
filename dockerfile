# Etapa 1: Usar uma imagem base oficial e leve do Python.
# A imagem 'slim' é uma excelente escolha, pois é menor que a padrão,
# mas mantém a compatibilidade com pacotes que a 'alpine' pode ter dificuldade.
FROM python:3.13.5-alpine3.22

# Etapa 2: Definir o diretório de trabalho dentro do contêiner.
# Isso evita que os arquivos da aplicação se espalhem pelo sistema de arquivos do contêiner.
WORKDIR /app

# Etapa 3: Copiar o arquivo de dependências primeiro.
# Isso aproveita o cache de camadas do Docker. Se o requirements.txt não mudar,
# o Docker não precisará reinstalar as dependências em cada build.
COPY requirements.txt .

# Etapa 4: Instalar as dependências.
# --no-cache-dir: Reduz o tamanho da imagem ao não armazenar o cache do pip.
# --upgrade pip: Garante que estamos usando a versão mais recente do pip.
RUN pip install --no-cache-dir --upgrade pip && pip install --no-cache-dir -r requirements.txt

# Etapa 5: Copiar o restante do código da aplicação.
COPY . .

# Etapa 6: Expor a porta em que a aplicação será executada.
EXPOSE 8000

# Etapa 7: Definir o comando para iniciar a aplicação.
# Usamos "0.0.0.0" para que o servidor seja acessível de fora do contêiner.
# A flag --reload é ideal para desenvolvimento, mas não para produção.
CMD ["uvicorn", "app:app", "--host", "0.0.0.0", "--port", "8000", "--reload"]
