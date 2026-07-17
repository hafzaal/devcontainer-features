#!/usr/bin/env bash
set -e

URL_SDK="https://dl.google.com/android/repository/commandlinetools-linux-14742923_latest.zip"
PLATFORM="platforms;android-${SDK_VERSION}"
BUILD_TOOLS="build-tools;${BUILD_TOOLS_VERSION}"
SOURCES="sources;android-${SDK_VERSION}"


export DEBIAN_FRONTEND="noninteractive"
apt-get update
apt-get install --no-install-recommends -y "openjdk-${JAVA_VERSION}-jdk-headless" usbutils wget unzip
apt-get clean

mkdir -p "$ANDROID_HOME"

cd "${ANDROID_HOME}"
wget -q "${URL_SDK}" -O androidsdk.zip
rm -rf \
    "${ANDROID_HOME}/cmdline-tools" \
    "${ANDROID_HOME}/cmdline-tools.tmp"
unzip androidsdk.zip


mv "${ANDROID_HOME}/cmdline-tools" "${ANDROID_HOME}/cmdline-tools.tmp"
mkdir "${ANDROID_HOME}/cmdline-tools"
mv "${ANDROID_HOME}/cmdline-tools.tmp" "${ANDROID_HOME}/cmdline-tools/latest"

rm androidsdk.zip

export PATH="$PATH:$ANDROID_HOME/cmdline-tools/latest/bin"

# Save original JAVA_HOME.
TEMP_JAVA_HOME="${JAVA_HOME:-}"
if ! JAVAC_PATH="$(command -v javac)"; then
    echo "Unable to locate javac after installing OpenJDK ${JAVA_VERSION}." >&2
    exit 1
fi
export JAVA_HOME="$(dirname "$(dirname "$(readlink -f "$JAVAC_PATH")")")"
yes | sdkmanager "platform-tools" "${PLATFORM}" "${BUILD_TOOLS}" "${SOURCES}"

chown -R "$_REMOTE_USER:$_REMOTE_USER" "$ANDROID_HOME"

export JAVA_HOME="${TEMP_JAVA_HOME}"