#!/usr/bin/env bash
set -euxo pipefail
git pull origin master
docker build . -t withings2garmin
