FROM python:3.7-stretch
LABEL maintainer="Leigh Johnson <hi@leighjohnson.me>"

ENV DEBIAN_FRONTEND noninteractive


RUN curl -sL https://deb.nodesource.com/setup_8.x | bash -
RUN apt-get -y update && \
  apt-get -y upgrade && \
  apt-get -y install git bzip2 nodejs && \
  apt-get purge && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/*
ENV LANG C.UTF-8

# install Python + NodeJS with conda
RUN npm install -g configurable-http-proxy && \
  python3 -m pip install jupyterhub \
  jupyterhub-kubespawner==0.9.0 \
  jupyterhub-dummyauthenticator \
  jhub_remote_user_authenticator \
  oauthenticator  --no-cache-dir 

RUN rm -rf ~/.cache ~/.npm

EXPOSE 8000

CMD ["jupyterhub"]