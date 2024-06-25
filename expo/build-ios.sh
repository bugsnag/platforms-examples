set -e

./build-common.sh

# specifying a working directory for the local eas build helps to avoid caching issues with metro
if [[ -z ${EAS_LOCAL_BUILD_WORKINGDIR:-} ]]; then
  EAS_LOCAL_BUILD_WORKINGDIR=$BUILDKITE_BUILD_CHECKOUT_PATH/build
  export EAS_LOCAL_BUILD_WORKINGDIR
fi

eas build \
  --local \
  -p ios \
  --output output.ipa \
  --non-interactive

