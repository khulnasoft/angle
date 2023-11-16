FROM docker.io/debian:bookworm-slim AS builder

WORKDIR /angle

COPY angle_*.deb ./
RUN dpkg -i angle_*_"$(dpkg --print-architecture)".deb

RUN mkdir -p /var/lib/angle

# distroless doesn't use static tags
# hadolint ignore=DL3007
FROM gcr.io/distroless/cc-debian11:latest

COPY --from=builder /usr/bin/angle /usr/bin/angle
COPY --from=builder /usr/share/doc/angle /usr/share/doc/angle
COPY --from=builder /usr/share/angle /usr/share/angle
COPY --from=builder /etc/angle /etc/angle
COPY --from=builder /var/lib/angle /var/lib/angle

# Smoke test
RUN ["angle", "--version"]

ENTRYPOINT ["/usr/bin/angle"]
