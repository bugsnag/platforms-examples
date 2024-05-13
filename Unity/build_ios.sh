#!/usr/bin/env bash

if [ -z "$UNITY_VERSION" ]
then
  echo "UNITY_VERSION must be set"
  exit 1
fi

UNITY_PATH="/Applications/Unity/Hub/Editor/$UNITY_VERSION/Unity.app/Contents/MacOS"

# Run unity and immediately exit afterwards, log all output
DEFAULT_CLI_ARGS="-quit -batchmode -nographics -logFile build.log"

project_path=`pwd`

# Build for Android
$UNITY_PATH/Unity $DEFAULT_CLI_ARGS -projectPath $project_path -executeMethod Builder.IosBuildA
RESULT=$?
if [ $RESULT -ne 0 ]; then exit $RESULT; fi
