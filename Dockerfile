FROM jazzdd/alpine-flask
USER root
COPY . /app/
WORKDIR /app/
RUN pip install --upgrade pip
EXPOSE 80
CMD [ "python3","app.py"]

