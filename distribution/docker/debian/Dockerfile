FROM docker.io/debian:bookworm-slim AS builder

WORKDIR /angle

COPY angle_*.deb ./
RUN dpkg -i angle_*_"$(dpkg --print-architecture)".deb

RUN mkdir -p /var/lib/angle

FROM docker.io/debian:bookworm-slim

# we want the latest versions of these
# hadolint ignore=DL3008
RUN apt-get update && apt-get install -y --no-install-recommends ca-certificates tzdata systemd && rm -rf /var/lib/apt/lists/*

COPY --from=builder /usr/bin/angle /usr/bin/angle
COPY --from=builder /usr/share/angle /usr/share/angle
COPY --from=builder /usr/share/doc/angle /usr/share/doc/angle
COPY --from=builder /etc/angle /etc/angle
COPY --from=builder /var/lib/angle /var/lib/angle

# Smoke test
RUN ["angle", "--version"]

ENTRYPOINT ["/usr/bin/angle"]
