FROM alpine:latest
ARG sims="vax vax780 vax8600 pdp11 pdp8 b5500 hp3000"

MAINTAINER Jordi Guillaumes Pons <jg@jordi.guillaumes.name>

ENV BUILDPKGS "git gcc libc-dev make vde2-dev libpcap-dev linux-headers readline-dev"
ENV RUNPKGS "net-tools vde2 vde2-libs libpcap nano readline bash"

RUN apk --update add $RUNPKGS && rm -rf /var/cache/apk/*

WORKDIR /workdir

RUN apk --update add --virtual build-dependencies $BUILDPKGS && \
	git clone git://github.com/simh/simh.git && \
	cd simh && \
	sed -e "s/\$(error Retry your build without specifying USE_NETWORK=1)/# SUPRESSED /g" makefile > makefile2 && \
	make LIBPATH=/usr/lib INCPATH=/usr/include USE_NETWORK=1 -f makefile2 $sims && \
	mkdir /simh-bin && cp -Rfv BIN/* /simh-bin 

ENV PATH /simh-bin:$PATH

EXPOSE 2323-2326

VOLUME /machines
WORKDIR /machines

ENTRYPOINT ["busybox", "sh"]
