# syntax=docker/dockerfile:1
FROM python:3.10-slim-buster
WORKDIR /app
COPY requirements.txt requirements.txt
RUN pip3 install -r requirements.txt
RUN apt update -y && apt install ffmpeg -y
COPY . .
CMD [ "python3", "-m" , "flask", "--app", "main", "run", "--host=0.0.0.0"]
