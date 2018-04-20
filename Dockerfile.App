FROM sudachen/py3flsk:latest

COPY ssh/host/id_rsa /etc/ssh/id_rsa
COPY ssh/host/id_rsa.pub /etc/ssh/id_rsa.pub
COPY ssh/root/id_rsa.pub /root/.ssh/authorized_keys

RUN chmod 700 /etc/ssh /root/.ssh && chmod 600 /etc/ssh/* /root/.ssh/*

COPY app /app
WORKDIR /app

RUN pip install -r "requirements.txt"


