FROM ubuntu:18.04

COPY requirements.txt /workspace/requirements.txt

# Variables
ENV JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
ENV PYSPARK_PYTHON=python3
ENV SPARK_VERSION=2.3.0
ENV HADOOP_VERSION=2.7
ENV SPARK_HOME=/opt/spark
ENV PATH=$SPARK_HOME/bin:$PATH

# Dependencias
RUN apt-get update && apt-get install -y \
    curl \
    wget \
    openjdk-8-jdk \
    python3.6 \
    python3-pip \
    python3-dev \
    build-essential \
    libffi-dev \
    libssl-dev \
    libargon2-0-dev \
    libjpeg-dev \
    zlib1g-dev \
    libpng-dev \
    software-properties-common \
    && rm -rf /var/lib/apt/lists/*

# Setear Python 3.6 como default
RUN update-alternatives --install /usr/bin/python python /usr/bin/python3.6 1

# PySpark
RUN pip3 install pyspark==2.3.0 && \
    pip3 install -r /workspace/requirements.txt


# Spark 2.3.0
RUN curl -L https://archive.apache.org/dist/spark/spark-${SPARK_VERSION}/spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz \
    | tar -xz -C /opt && \
    mv /opt/spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION} /opt/spark

# Jupyter
RUN pip3 install --upgrade pip setuptools wheel
RUN pip3 install notebook==6.4.10

WORKDIR /workspace

EXPOSE 8888

# Jupyter Notebooks como default
CMD ["jupyter", "notebook", "--ip=0.0.0.0", "--port=8888", "--no-browser", "--allow-root", "--NotebookApp.token=", "--NotebookApp.password="]
