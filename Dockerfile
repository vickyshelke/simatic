FROM resin/i386-debian:jessie

LABEL io.resin.device-type="iot2000"

RUN apt-get -q update && apt-get install -yq --no-install-recommends \
        ntp \
        git-core \
        build-essential \
        gcc \
        python \
        python-dev \
        python-pip \
        python-virtualenv \
        snmpd \
        snmp \
&& apt-get clean && rm -rf /var/lib/apt/lists/*
# Set our working directory
WORKDIR /usr/src/app
# This will copy all files in our root to the working  directory in the container
COPY . ./

# switch on systemd init system in container
ENV INITSYSTEM on

# main.py will run when container starts up on the device
CMD ["python", "gpio.py"]
