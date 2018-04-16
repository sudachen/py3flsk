FROM sudachen/py3flsk:latest

COPY app /app
WORKDIR /app

RUN pip install -r "requirements.txt"

