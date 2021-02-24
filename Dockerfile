FROM jazzdd/alpine-flask
USER root
COPY . /app/
WORKDIR /app/
RUN pip3 install --upgrade pip3
EXPOSE 80
CMD [ "python3","app.py"]

