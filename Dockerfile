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
    && python3 -m pip install --upgrade pip \
    && python3 -m pip install setuptools

RUN python3 -m pip install scif==0.0.81

# Install the filesystem from the recipe
COPY *.scif /
RUN scif install /recipe.scif

# Cleanup APT
RUN apt-get clean \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# SciF Entrypoint
ENTRYPOINT ["scif"]
