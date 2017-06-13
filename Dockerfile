FROM ubuntu:16.04
MAINTAINER Sahand Hariri sahandha@gmail.com

RUN apt-get update && apt-get install -y sudo && rm -rf /var/lib/apt/lists/*
RUN apt-get -qq update
RUN apt-get -qq -y install wget && \
apt-get -qq -y install bzip2
RUN apt-get update
RUN sudo apt-get -qq -y install software-properties-common

#Install anaconda which includes python 2.7 and jupyter
#RUN wget https://repo.continuum.io/archive/Anaconda2-4.2.0-Linux-x86_64.sh -O /tmp/miniconda.sh
#RUN sudo bash /tmp/miniconda.sh -f -b -p /opt/conda && \
#/opt/conda/bin/pip install --upgrade pip
#ENV PATH=/opt/conda/bin:$PATH

RUN apt-get install -y python
RUN sudo apt-get install -y python-pip python-dev build-essential
RUN pip install --upgrade pip
RUN pip install jupyter
ENV PATH=/home/ubuntu/.local/bin:$PATH


#RUN jupyter notebook --generate-config -y
RUN sed -i -e 's/#c.NotebookApp.ip\ =\ \x27localhost\x27/c.NotebookApp.ip\ =\ \x27*\x27/g' ~/.jupyter/jupyter_notebook_config.py
RUN sed -i -e 's/#c.NotebookApp.open_browser\ =\ True/c.NotebookApp.open_browser\ =\ False/g' ~/.jupyter/jupyter_notebook_config.py
RUN sed -i -e 's/#c.NotebookApp.port/c.NotebookApp.port/g' ~/.jupyter/jupyter_notebook_config.py
EXPOSE 8888

#Install java
RUN echo debconf shared/accepted-oracle-license-v1-1 select true | \
sudo debconf-set-selections
RUN echo debconf shared/accepted-oracle-license-v1-1 seen true | \
sudo debconf-set-selections

RUN sudo apt-add-repository ppa:webupd8team/java
RUN sudo apt-get update
RUN sudo apt-get -qq -y install oracle-java7-installer

#Install scala
#RUN wget http://www.scala-lang.org/files/archive/scala-2.12.0.tgz
#RUN sudo mkdir /usr/local/src/scala
#RUN sudo tar xvf scala-2.12.0.tgz -C /usr/local/src/scala/
#RUN rm scala-2.12.0.tgz

#ENV SCALA_HOME=/usr/local/src/scala/scala-2.12.0
#ENV PATH=$SCALA_HOME/bin:$PATH

RUN wget http://d3kbcqa49mib13.cloudfront.net/spark-2.0.2-bin-hadoop2.7.tgz 
RUN tar xvf spark-2.0.2-bin-hadoop2.7.tgz
RUN rm spark-2.0.2-bin-hadoop2.7.tgz
RUN mv spark-2.0.2-bin-hadoop2.7 /opt/spark

RUN mkdir /external/spark-jupyter

#CMD cd /external/spark-jupyter && PYSPARK_DRIVER_PYTHON="jupyter" PYSPARK_DRIVER_PYTHON_OPTS="notebook" /opt/spark/bin/pyspark
CMD cd /external/spark-jupyter && PYSPARK_DRIVER_PYTHON="jupyter" PYSPARK_DRIVER_PYTHON_OPTS="notebook" 
