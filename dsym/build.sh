#!/usr/bin/env bash

set -o errexit

xcrun xcodebuild \
  -scheme dSYM-Example \
  -destination generic/platform=iOS \
  -configuration Debug \
  -archivePath archive/dSYM-Example.xcarchive \
  -allowProvisioningUpdates \
  -quiet \
  archive \
  CLANG_ENABLE_MODULES=NO \
  GCC_PREPROCESSOR_DEFINITIONS='$(inherited) BSG_LOG_LEVEL=BSG_LOGLEVEL_DEBUG BSG_KSLOG_ENABLED=1'

echo "--- iOSTestApp: xcodebuild -exportArchive"

xcrun xcodebuild \
  -exportArchive \
  -archivePath archive/dSYM-Example.xcarchive \
  -destination generic/platform=iOS \
  -exportPath output/ \
  -quiet \
  -exportOptionsPlist exportOptions.plist
