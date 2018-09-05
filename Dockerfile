FROM resin/i386-debian:jessie

LABEL io.resin.device-type="iot2000"

RUN apt-get update && apt-get install -y --no-install-recommends \
		less \
		kmod \
		nano \
		net-tools \
		ifupdown \	
		iputils-ping \	
		i2c-tools \
		usbutils \	
	&& rm -rf /var/lib/apt/lists/*
RUN set -x \
	&& buildDeps='git-core autoconf libtool automake build-essential debhelper fakeroot cmake dpkg-dev devscripts' \
	&& apt-get update && apt-get install -y $buildDeps --no-install-recommends && rm -rf /var/lib/apt/lists/* \
	&& git clone https://github.com/mdr78/libx1000.git \
	&& cd libx1000 \
	&& git checkout 1bfb62bb62e0ebe0e42817edd9702d91d232dbee \
	&& cd libx1000-0.0.0 \
	&& libtoolize --force \
	&& aclocal \
	&& autoheader \
	&& automake --force-missing --add-missing \
	&& autoconf \
	&& ./autogen.sh \
	&& ./configure \
	&& make && make install \
	&& apt-get purge -y --auto-remove $buildDeps \
&& cd / && rm -rf /libx1000
# Set our working directory
WORKDIR /usr/src/app

# Copy requirements.txt first for better cache on later pushes
COPY ./requirements.txt /requirements.txt

# pip install python deps from requirements.txt on the resin.io build server
RUN pip install -r /requirements.txt

# This will copy all files in our root to the working  directory in the container
COPY . ./

# switch on systemd init system in container
ENV INITSYSTEM on

# main.py will run when container starts up on the device
CMD ["python", "gpio.py"]
