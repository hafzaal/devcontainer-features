
# Android SDK (android-sdk)

Installs the Android SDK and command line tools.

## Example Usage

```json
"features": {
    "ghcr.io/hafzaal/devcontainer-features/android-sdk:1": {}
}
```

## Options

| Options Id | Description | Type | Default Value |
|-----|-----|-----|-----|
| android_home | The directory in which to install the Android SDK. | string | /usr/local/lib/android |
| sdk_version | The version of the Android SDK to install. | string | 36 |
| build_tools_version | The version of the Android build tools to install. | string | 36.0.0 |
| java_version | The version of Java to install. | string | 25 |
| repo_os_override | Override the OS for the Android SDK repository. Useful for cross-platform builds | string | linux |



---

_Note: This file was auto-generated from the [devcontainer-feature.json](https://github.com/hafzaal/devcontainer-features/blob/main/src/android-sdk/devcontainer-feature.json).  Add additional notes to a `NOTES.md`._
