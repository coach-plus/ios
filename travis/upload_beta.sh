#!/bin/sh
sudo gem install fastlane --no-ri --no-rdoc --no-document

fastlane upload_beta --verbose &

# Output to the screen every minute to prevent a travis timeout
export PID=$!
while [[ `ps -p $PID | tail -n +2` ]]; do
  echo 'Uploading..'
  sleep 60
done