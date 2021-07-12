FROM jasonrivers/nagios:latest

RUN apt-get update && apt-get install -y    \
	php-curl \
        python3-pip \
    && rm -rf /var/lib/apt/lists/* \
    && pip install speedtest-cli
