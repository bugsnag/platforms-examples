#!/usr/bin/env bash

if [ -z "$UNITY_VERSION" ]
then
  echo "UNITY_VERSION must be set"
  exit 1
fi

UNITY_PATH="/Applications/Unity/Hub/Editor/$UNITY_VERSION/Unity.app/Contents/MacOS"

# Run unity and immediately exit afterwards, log all output
DEFAULT_CLI_ARGS="-quit -nographics -batchmode -logFile build.log -buildTarget iOS"

project_path=$(pwd)

# Generate the Xcode project for iOS
$UNITY_PATH/Unity $DEFAULT_CLI_ARGS -projectPath $project_path -executeMethod Builder.IosBuild
RESULT=$?
if [ $RESULT -ne 0 ]; then exit $RESULT; fi

# Unity needs an -ObjC linker flag but using the undocumented SetAdditionalIl2CppArgs method appears to have no effect
# a clean build. Building the project twice is a temporary workaround that circumnavigates what
# appears to be a platform bug.
# For further context see https://answers.unity.com/questions/1610105/how-to-add-compiler-or-linker-flags-for-il2cpp-inv.html
$UNITY_PATH/Unity $DEFAULT_CLI_ARGS -projectPath $project_path -executeMethod Builder.IosBuild
RESULT=$?
if [ $RESULT -ne 0 ]; then exit $RESULT; fi

# ARCHIVE (equivalent to Product > Archive)
xcrun xcodebuild \
  -project "$project_path/UnityExample/Unity-iPhone.xcodeproj" \
  -scheme Unity-iPhone \
  -configuration Release \
  clean archive \
  -allowProvisioningUpdates \
  -allowProvisioningDeviceRegistration \
  -quiet \
  GCC_WARN_INHIBIT_ALL_WARNINGS=YES

if [ $? -ne 0 ]; then
  echo "Failed to archive project"
  exit 1
fi

