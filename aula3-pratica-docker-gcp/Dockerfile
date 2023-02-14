FROM python:3

# We copy just the requirements.txt first to leverage Docker cache
COPY ./requirements.txt /app/requirements.txt

WORKDIR /app

RUN pip install --no-cache-dir -r requirements.txt

COPY . /app

# comando para startar o codigo dentro do container (no caso de agora com o codigo em Python)
ENTRYPOINT [ "python" ]

# mostrando para o comando entrypoint qual o arquivo principal para ser executado
CMD [ "app.py" ]
