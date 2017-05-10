#!/bin/sh
sudo gem install fastlane --no-ri --no-rdoc --no-document
travis_wait 30 fastlane upload_beta --verbose