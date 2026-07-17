#!/usr/bin/env bash
set -e

URL_SDK="https://dl.google.com/android/repository/commandlinetools-linux-14742923_latest.zip"
PLATFORM="platforms;android-${SDK_VERSION}"
BUILD_TOOLS="build-tools;${BUILD_TOOLS_VERSION}"
SOURCES="sources;android-${SDK_VERSION}"
CONTAINER_PACKAGES=("platform-tools" "${PLATFORM}" "${BUILD_TOOLS}")
HOST_PACKAGES=("platform-tools" "emulator" "${PLATFORM}" "${BUILD_TOOLS}" "${SOURCES}")


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
yes | sdkmanager "${CONTAINER_PACKAGES[@]}"

chown -R "$_REMOTE_USER:$_REMOTE_USER" "$ANDROID_HOME"

if [ "${SETUP_HOST_SDK}" = "true" ]; then
    case "${HOST_OS}" in
        linux|windows|macosx)
            ;;
        *)
            echo "HOST_OS must be one of: linux, windows, macosx" >&2
            exit 1
            ;;
    esac

    if [ "$HOST_SDK_DIR" = "$ANDROID_HOME" ]; then
        echo "HOST_SDK_DIR must be different from ANDROID_HOME" >&2
        exit 1
    fi

    mkdir -p "$HOST_SDK_DIR"
    yes | REPO_OS_OVERRIDE="$HOST_OS" sdkmanager --sdk_root="$HOST_SDK_DIR" "${HOST_PACKAGES[@]}" "emulator"
    chown -R "$_REMOTE_USER:$_REMOTE_USER" "$HOST_SDK_DIR"
fi

export JAVA_HOME="${TEMP_JAVA_HOME}"