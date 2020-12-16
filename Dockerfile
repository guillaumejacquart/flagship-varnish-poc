FROM varnish:6.5

RUN apt-get update
RUN apt-get install -y python3 python3-docutils git wget varnish-dev libtool m4 automake python-docutils make

RUN update-alternatives --install /usr/bin/python python /usr/bin/python3 1

RUN wget https://github.com/varnish/varnish-modules/archive/varnish-modules-0.17.0.tar.gz
RUN tar -xzvf varnish-modules-0.17.0.tar.gz && mv varnish-modules-varnish-modules-0.17.0 varnish-modules
RUN cd varnish-modules && ./bootstrap && ./configure && make && make install

ADD ./libvmod-flagship ./libvmod-flagship
ADD ./go-wrapper/libflagship.h /usr/include/libflagship.h
ADD ./go-wrapper/libflagship.so /usr/lib/libflagship.so

WORKDIR /etc/varnish/libvmod-flagship/

RUN mkdir -p /usr/include/
RUN mkdir -p /usr/lib/

RUN rm libflagship.so libflagship.h

RUN ./autogen.sh
RUN ./configure --disable-dependency-tracking
RUN make
RUN make install