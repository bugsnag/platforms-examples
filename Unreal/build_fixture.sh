#!/bin/bash

set -o errexit
set -o nounset

PLATFORM=$1

UPROJECT="${PWD}/bugsnag_example_5_3.uproject"

UE_VERSION="${UE_VERSION:-5.3}"
UE_HOME="/Users/Shared/Epic Games/UE_${UE_VERSION}"
UE_BUILD="${UE_HOME}/Engine/Build/BatchFiles/Mac/Build.sh"
UE_RUNUAT="${UE_HOME}/Engine/Build/BatchFiles/RunUAT.sh"

echo "--- Building Editor dependencies"

"${UE_BUILD}" bugsnag_example_5_3 Mac Development -TargetType=Editor -ForceUnity "${UPROJECT}"


echo "--- Building test fixture"

RUNUAT_ARGS=(BuildCookRun -project="${UPROJECT}" -targetplatform="${PLATFORM}" -clientconfig=Shipping)
RUNUAT_ARGS+=(-build -nocompileeditor -ubtargs=-ForceUnity)
RUNUAT_ARGS+=(-cook -compressed -pak)
RUNUAT_ARGS+=(-stage -prereqs)
RUNUAT_ARGS+=(-package)

case "${PLATFORM}" in
  Android)  RUNUAT_ARGS+=(-distribution) ;;
  Mac)      RUNUAT_ARGS+=(-archive) ;;
esac

"${UE_RUNUAT}" "${RUNUAT_ARGS[@]}" -unattended -utf8output


echo "--- Preparing artifact(s) for upload"

case "${PLATFORM}" in
  Android)
    mv Binaries/Android/bugsnag_example_5_3-Android-Shipping-arm64.apk build/bugsnag_example_5_3-Android-Shipping-arm64.apk
    if [[ -f Binaries/Android/bugsnag_example_5_3-Android-Shipping-armv7.apk ]]; then
      mv Binaries/Android/bugsnag_example_5_3-Android-Shipping-armv7.apk build/bugsnag_example_5_3-Android-Shipping-armv7.apk
    fi
    ;;

  IOS)
    mv Binaries/IOS/bugsnag_example_5_3-IOS-Shipping.dSYM build/bugsnag_example_5_3-IOS-Shipping.dSYM
    mv Binaries/IOS/bugsnag_example_5_3-IOS-Shipping.ipa build/bugsnag_example_5_3-IOS-Shipping.ipa
    ;;

  Mac)
    mv ArchivedBuilds/Mac/ ArchivedBuilds/MacNoEditor/
    zip -r bugsnag_example_5_3-macOS.zip ArchivedBuilds
    ;;
esac
