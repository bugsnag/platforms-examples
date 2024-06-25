#!/bin/bash -e

# Lets make sure the build folders were cleared out correctly
rm -rf $BUILDKITE_BUILD_CHECKOUT_PATH/build/*

# And all previous packages are removed
git clean -xfdf

# And the yarn cache is clean
yarn cache clean --all

# Install repo dependencies
yarn install

# Set EAS Project ID
sed -i '' "s/EXPO_EAS_PROJECT_ID/$EXPO_EAS_PROJECT_ID/g" app.json

cp $EXPO_UNIVERSAL_CREDENTIALS_DIR/* .

echo "Common setup complete"

