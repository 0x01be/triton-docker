FROM alpine:3.12.0 as builder

RUN apk add --no-cache --virtual build-dependencies \
    --repository http://dl-cdn.alpinelinux.org/alpine/edge/testing \
    --repository http://dl-cdn.alpinelinux.org/alpine/edge/community \
    --repository http://dl-cdn.alpinelinux.org/alpine/edge/main \
    git \
    build-base \
    cmake \
    bison \
    boost-dev \
    zlib-dev

RUN git clone --depth 1 https://github.com/The-OpenROAD-Project/TritonRoute /triton

RUN mkdir /triton/build
WORKDIR /triton/build

RUN cmake -DCMAKE_INSTALL_PREFIX=/opt/triton/ ..
RUN make
RUN make install

FROM alpine:3.12.0

COPY --from=builder /opt/triton/ /opt/triton/

ENV PATH $PATH:/opt/triton/bin/

