ARG RUST_VERSION
ARG DEBIAN_RELEASE=bookworm
# Features required for both Agent and Aggregator Helm chart configurations
ARG FEATURES=api,api-client,sources-datadog_agent,sources-fluent,sources-host_metrics,sources-internal_metrics,sources-kubernetes_logs,sources-logstash,sources-splunk_hec,sources-statsd,sources-syslog,sources-angle,sinks-console,sinks-prometheus,sinks-angle

#
# ANGLE BUILDER
#
FROM docker.io/rust:${RUST_VERSION}-${DEBIAN_RELEASE} as builder
RUN apt-get update && apt-get -y --no-install-recommends install build-essential git clang cmake libclang-dev libsasl2-dev libstdc++-11-dev libssl-dev libxxhash-dev zlib1g-dev zlib1g
RUN git clone https://github.com/rui314/mold.git \
    && mkdir mold/build \
    && cd mold/build \
    && git checkout v2.0.0 \
    && ../install-build-deps.sh \
    && cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_CXX_COMPILER=c++ .. \
    && cmake --build . -j $(nproc) \
    && cmake --install .

WORKDIR /angle
COPY . .
ARG FEATURES
RUN scripts/environment/install-protoc.sh
RUN --mount=type=cache,target=/angle/target \
    --mount=type=cache,target=/usr/local/cargo/registry \
    --mount=type=cache,target=/usr/local/cargo/git \
    /usr/local/bin/mold -run cargo build --bin angle \
    --no-default-features --features $FEATURES && \
    cp target/debug/angle .

#
# TARGET
#
FROM docker.io/debian:${DEBIAN_RELEASE}-slim
RUN apt-get update && apt-get -y --no-install-recommends install zlib1g && rm -rf /var/lib/apt/lists/*
COPY --from=builder /angle/angle /usr/bin/angle
RUN mkdir -p /var/lib/angle

# Smoke test
RUN ["angle", "--version"]

ENTRYPOINT ["/usr/bin/angle"]
