FROM 0x01be/base as build

ENV REVISION=openroad
RUN apk add --no-cache --virtual triton-build-dependencies \
    git \
    build-base \
    cmake \
    bison \
    flex \
    boost-dev \
    zlib-dev \
    libgomp &&\
    git clone --depth 1 https://github.com/The-OpenROAD-Project/TritonRoute /triton

WORKDIR /triton/build

RUN cmake \
    -DCMAKE_INSTALL_PREFIX=/opt/triton/ \
    .. &&\
    make &&\
    sed -i.bak 's/^.*frCMap.h.*$//g' cmake_install.cmake
RUN make install

FROM 0x01be/base

COPY --from=build /opt/triton/ /opt/triton/

WORKDIR /workspace

RUN apk add --no-cache --virtual triton-runtime-dependencies \
    libstdc++ \
    libgomp &&\
    adduser -D -u 1000 triton &&\
    chown triton:triton /workspace

USER triton
ENV PATH=${PATH}:/opt/triton/bin/

