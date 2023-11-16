FROM docker.io/alpine:3.18 AS builder

WORKDIR /angle

COPY angle-*-unknown-linux-musl*.tar.gz ./
RUN tar -xvf angle-0*-"$(cat /etc/apk/arch)"-unknown-linux-musl*.tar.gz --strip-components=2

RUN mkdir -p /var/lib/angle

FROM docker.io/alpine:3.18
# we want the latest versions of these
# hadolint ignore=DL3018
RUN apk --no-cache add ca-certificates tzdata

COPY --from=builder /angle/bin/* /usr/local/bin/
COPY --from=builder /angle/config/angle.yaml /etc/angle/angle.yaml
COPY --from=builder /var/lib/angle /var/lib/angle

# Smoke test
RUN ["angle", "--version"]

ENTRYPOINT ["/usr/local/bin/angle"]
