set -e

./build-common.sh

eas build \
  --local \
  -p android \
  --output output.apk
