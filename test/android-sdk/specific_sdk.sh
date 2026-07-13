#!/bin/bash
set -e

source dev-container-features-test-lib

check "adb is installed" bash -c "adb --version"
check "custom Android platform is installed" bash -c "sdkmanager --list_installed | grep -q 'platforms;android-35'"
check "custom build tools are installed" bash -c "sdkmanager --list_installed | grep -q 'build-tools;35.0.0'"

reportResults
