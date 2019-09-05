FROM debian:stretch
MAINTAINER Chris Mungall <cjmungall@lbl.gov>

RUN apt-get update && apt-get -y install autoconf build-essential
RUN apt-get install -y pkg-config

WORKDIR /xml-make
COPY . /xml-make
RUN make
CMD ./make-4.1/bin/xml-make4.1
