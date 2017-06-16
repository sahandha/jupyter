FROM continuumio/miniconda3

MAINTAINER Sahand Hariri sahandha@gmail.com

RUN apt-get update && apt-get install -yq --no-install-recommends \
    wget \
    unzip \
    software-properties-common \
    && apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN pip install jupyter && mkdir /opt/notebooks
RUN jupyter notebook --generate-config --allow-root \
&& sed -i -e 's/#c.NotebookApp.ip\ =\ \x27localhost\x27/c.NotebookApp.ip\ =\ \x27*\x27/g' ~/.jupyter/jupyter_notebook_config.py \
&& sed -i -e 's/#c.NotebookApp.open_browser\ =\ True/c.NotebookApp.open_browser\ =\ False/g' ~/.jupyter/jupyter_notebook_config.py \
&& sed -i -e 's/#c.NotebookApp.port/c.NotebookApp.port/g' ~/.jupyter/jupyter_notebook_config.py \
&& sed -i -e 's/#c.NotebookApp.allow_root\ =\ False/c.NotebookApp.allow_root\ =\ True/g' ~/.jupyter/jupyter_notebook_config.py

EXPOSE 8888

RUN conda install numpy scipy matplotlib seaborn


#Install java
RUN echo debconf shared/accepted-oracle-license-v1-1 select true | debconf-set-selections
RUN echo debconf shared/accepted-oracle-license-v1-1 seen true | debconf-set-selections

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

