#!/usr/bin/env bash
set -euxo pipefail
git pull origin main
docker build . -t withings2garmin
