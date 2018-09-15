FROM ubuntu:16.04 as build

# Requirements for Astron
RUN apt-get update && \
    apt-get install -y cmake \
                       g++ \
                       libssl-dev \
                       libyaml-cpp-dev \
                       libboost-all-dev
WORKDIR /build

COPY src src
COPY cmake cmake
COPY CMakeLists.txt .

RUN cmake -DCMAKE_BUILD_TYPE=Release . && make

FROM ubuntu:16.04
RUN apt-get update && \
    apt-get install -y libssl-dev \
                       libyaml-cpp-dev \
                       libboost-all-dev

WORKDIR /astron

COPY --from=build /build/astrond astrond

ENV CLUSTER_CONFIG="cluster.yml"
ENV LOGLEVEL="info"

CMD ./astrond --loglevel $LOGLEVEL $CLUSTER_CONFIG
