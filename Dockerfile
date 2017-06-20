FROM python:3.5-slim
MAINTAINER Sahand Hariri sahandha@gmail.com

RUN apt-get update && apt-get install -y sudo && rm -rf /var/lib/apt/lists/*
RUN apt-get -qq update
RUN apt-get -qq -y install wget \
&&  apt-get -qq -y install bzip2
RUN apt-get update
RUN sudo apt-get -qq -y install software-properties-common

RUN sudo apt-get install -y python-pip python-dev build-essential 
RUN pip install --upgrade pip \
&& pip install jupyter \
&& pip install numpy scipy matplotlib seaborn 
ENV PATH=/home/ubuntu/.local/bin:$PATH


RUN jupyter notebook --generate-config --allow-root \
&& sed -i -e 's/#c.NotebookApp.ip\ =\ \x27localhost\x27/c.NotebookApp.ip\ =\ \x27*\x27/g' ~/.jupyter/jupyter_notebook_config.py \
&& sed -i -e 's/#c.NotebookApp.open_browser\ =\ True/c.NotebookApp.open_browser\ =\ False/g' ~/.jupyter/jupyter_notebook_config.py \
&& sed -i -e 's/#c.NotebookApp.port/c.NotebookApp.port/g' ~/.jupyter/jupyter_notebook_config.py \
&& sed -i -e 's/#c.NotebookApp.allow_root\ =\ False/c.NotebookApp.allow_root\ =\ True/g' ~/.jupyter/jupyter_notebook_config.py

EXPOSE 8888

RUN apt-get update
RUN apt-get install -yq default-jdk

RUN wget http://d3kbcqa49mib13.cloudfront.net/spark-2.0.2-bin-hadoop2.7.tgz 
RUN tar xvf spark-2.0.2-bin-hadoop2.7.tgz
RUN rm spark-2.0.2-bin-hadoop2.7.tgz
RUN mv spark-2.0.2-bin-hadoop2.7 /opt/spark

WORKDIR /external/spark-jupyter

ENV PYSPARK_DRIVER_PYTHON="jupyter" 
ENV PYSPARK_DRIVER_PYTHON_OPTS="notebook" 

CMD /opt/spark/bin/pyspark  
