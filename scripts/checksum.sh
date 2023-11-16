#!/usr/bin/env bash
set -euo pipefail

# checksum.sh
#
# SUMMARY
#
#   Creates a SHA256 checksum of all artifacts created during CI

ROOT=$(git rev-parse --show-toplevel)
ANGLE_VERSION=${ANGLE_VERSION:-nightly}

pushd "${ROOT}/target/artifacts"

shopt -s extglob
ARTIFACTS=(!(*SHA256SUMS))
shopt -u extglob

sha256sum "${ARTIFACTS[@]}" > angle-"$ANGLE_VERSION"-SHA256SUMS

popd
