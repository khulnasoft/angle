#!/bin/bash
set -euo pipefail

# sync-install.sh
#
# SUMMARY
#
#   Syncs the install.sh script to S3 where it is served for
#   https://sh.angle.com.
#

aws s3 cp distribution/install.sh s3://sh.angle.khulnasoft.com --sse --acl public-read
