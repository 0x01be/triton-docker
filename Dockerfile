FROM alpine as build

RUN apk add --no-cache --virtual triton-build-dependencies \
    git \
    build-base \
    cmake \
    bison \
    flex \
    boost-dev \
    zlib-dev \
    libgomp

ENV REVISION=openroad
RUN git clone --depth 1 https://github.com/The-OpenROAD-Project/TritonRoute /triton

WORKDIR /triton/build

RUN cmake \
    -DCMAKE_INSTALL_PREFIX=/opt/triton/ \
    .. &&\
    make &&\
    sed -i.bak 's/^.*frCMap.h.*$//g' cmake_install.cmake &&\
    make install

FROM alpine

RUN apk add --no-cache --virtual triton-runtime-dependencies \
    libstdc++ \
    libgomp

COPY --from=build /opt/triton/ /opt/triton/

RUN adduser -D -u 1000 triton

WORKDIR /workspace

RUN chown triton:triton /workspace

USER triton

ENV PATH $PATH:/opt/triton/bin/

