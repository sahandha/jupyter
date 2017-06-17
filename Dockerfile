FROM jupyter/base-notebook


MAINTAINER Sahand Hariri sahandha@gmail.com

USER root

# Install all OS dependencies for fully functional notebook server
RUN apt-get update && apt-get install -yq --no-install-recommends \
    wget \
    vim \
    unzip \
    python-dev \
    software-properties-common \
    && apt-get clean && \
    rm -rf /var/lib/apt/lists/*


#Install java
RUN echo debconf shared/accepted-oracle-license-v1-1 select true | \
debconf-set-selections
RUN echo debconf shared/accepted-oracle-license-v1-1 seen true | \
debconf-set-selections

#RUN apt-add-repository ppa:webupd8team/java
RUN apt-get update
RUN apt-get install -yq default-jdk
#RUN apt-get -qq -y install oracle-java9-installer

RUN wget http://d3kbcqa49mib13.cloudfront.net/spark-2.0.2-bin-hadoop2.7.tgz 
RUN tar xvf spark-2.0.2-bin-hadoop2.7.tgz
RUN rm spark-2.0.2-bin-hadoop2.7.tgz
RUN mv spark-2.0.2-bin-hadoop2.7 /opt/spark

RUN mkdir -p /external/spark-jupyter
RUN chmod 776 /external/spark-jupyter
# Switch back to jovyan to avoid accidental container runs as root
USER $NB_USER

RUN sudo cd /external/spark-jupyter
CMD PYSPARK_DRIVER_PYTHON="jupyter" PYSPARK_DRIVER_PYTHON_OPTS="notebook" /opt/spark/bin/pyspark 

