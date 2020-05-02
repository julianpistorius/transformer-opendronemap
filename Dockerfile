FROM opendronemap/odm:0.9.1 as builder
WORKDIR /

FROM phusion/baseimage
# Env variables
ENV DEBIAN_FRONTEND noninteractive
WORKDIR /
COPY --from=builder /code /code

#Install dependencies
RUN apt-get update -y \
    && apt-get install --no-install-recommends -y \
    software-properties-common \
    python3-pip \
    wget \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
    && python3 -m pip install --upgrade pip \
    && python3 -m pip install setuptools

RUN wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O miniconda.sh \
    && bash miniconda.sh -b
RUN  ~/miniconda3/bin/conda update -n base -c defaults conda

RUN python3 -m pip install scif==0.0.81

COPY . /scif/apps/odm/src/

# Install the filesystem from the recipe
COPY *.scif /
RUN scif install /recipe.scif

# Cleanup APT
RUN apt-get clean \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# SciF Entrypoint
ENTRYPOINT ["scif"]
