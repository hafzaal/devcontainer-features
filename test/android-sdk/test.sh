#!/bin/bash
#
# Run the tests using:
#devcontainer features test \
#  --project-folder . \
#  --features android-sdk \
#  --base-image trixie
#
set -e

source dev-container-features-test-lib

check "adb is installed" bash -c "adb --version"
check "sdkmanager is installed" bash -c "sdkmanager --version"
check "default Android platform is installed" bash -c "sdkmanager --list_installed | grep -q 'platforms;android-36'"
check "default build tools are installed" bash -c "sdkmanager --list_installed | grep -q 'build-tools;36.0.0'"

reportResults
