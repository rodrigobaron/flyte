#!/usr/bin/env bash

set -e

# Create dir structure
mkdir -p release

# Copy all deployment manifest in release directory
for file in ./deployment/**/flyte_generated.yaml; do 
    if [ -f "$file" ]; then
        result=${file/#"./deployment/"}
        result=${result/%"/flyte_generated.yaml"}
        cp $file "./release/flyte_${result}_manifest.yaml"
    fi
done

grep -rlZ "version:[^P]*# VERSION" ./charts/flyte/Chart.yaml | xargs -0 sed -i "s/version:[^P]*# VERSION/version: ${VERSION} # VERSION/g"
grep -rlZ "version:[^P]*# VERSION" ./charts/flyte-sandbox/Chart.yaml | xargs -0 sed -i "s/version:[^P]*# VERSION/version: ${VERSION} # VERSION/g"
grep -rlZ "repository:[^P]*# REPOSITORY" ./charts/flyte-sandbox/Chart.yaml | xargs -0 sed -i "s/repository:[^P]*# REPOSITORY/repository: ${REPOSITORY} # REPOSITORY/g"
sed "s/v0.1.10/${VERSION}/g" ./charts/flyte-core/README.md  > temp.txt && mv temp.txt ./charts/flyte-sandbox/README.md
sed "s/v0.1.10/${VERSION}/g" ./charts/flyte/README.md  > temp.txt && mv temp.txt ./charts/flyte/README.md 
helm dep update ./charts/flyte
