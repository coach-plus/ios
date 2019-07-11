fastlane documentation
================
# Installation

Make sure you have the latest version of the Xcode command line tools installed:

```
xcode-select --install
```

Install _fastlane_ using
```
[sudo] gem install fastlane -NV
```
or alternatively using `brew cask install fastlane`

# Available Actions
## iOS
### ios test
```
fastlane ios test
```
Runs all the tests
### ios build_dev
```
fastlane ios build_dev
```
build dev
### ios setup_keychain
```
fastlane ios setup_keychain
```

### ios build_beta
```
fastlane ios build_beta
```

### ios upload_beta
```
fastlane ios upload_beta
```

### ios release
```
fastlane ios release
```
Deploy a new version to the App Store
### ios build_production
```
fastlane ios build_production
```


----

This README.md is auto-generated and will be re-generated every time [fastlane](https://fastlane.tools) is run.
More information about fastlane can be found on [fastlane.tools](https://fastlane.tools).
The documentation of fastlane can be found on [docs.fastlane.tools](https://docs.fastlane.tools).
