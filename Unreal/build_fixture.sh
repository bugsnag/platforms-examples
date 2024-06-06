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

"${UE_BUILD}" TestFixture Mac Development -TargetType=Editor -ForceUnity "${UPROJECT}"


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
    mv features/fixtures/generic/Binaries/Android/TestFixture-Android-Shipping-arm64.apk build/TestFixture-Android-Shipping-"${UE_VERSION}"-arm64.apk
    if [[ -f features/fixtures/generic/Binaries/Android/TestFixture-Android-Shipping-armv7.apk ]]; then
      mv features/fixtures/generic/Binaries/Android/TestFixture-Android-Shipping-armv7.apk build/TestFixture-Android-Shipping-"${UE_VERSION}"-armv7.apk
    fi
    ;;

  IOS)
    mv features/fixtures/generic/Binaries/IOS/TestFixture-IOS-Shipping.dSYM build/TestFixture-IOS-Shipping-"${UE_VERSION}".dSYM
    mv features/fixtures/generic/Binaries/IOS/TestFixture-IOS-Shipping.ipa build/TestFixture-IOS-Shipping-"${UE_VERSION}".ipa
    ;;

  Mac)
    mv features/fixtures/generic/ArchivedBuilds/Mac/ features/fixtures/generic/ArchivedBuilds/MacNoEditor/
    zip -r TestFixture-macOS-"${UE_VERSION}".zip features/fixtures/generic/ArchivedBuilds
    ;;
esac
