#!/bin/bash

#rm -rf dsymsDev
#rm -rf dsymsBeta
#rm -rf dsymsProd
#unzip CoachPlusDev.app.dSYM.zip -d dsymsDev
#unzip CoachPlusBeta.app.dSYM.zip -d dsymsBeta
#unzip CoachPlus.app.dSYM.zip -d dsymsProd
docker pull getsentry/sentry-cli
docker run --rm -v $(pwd):/work getsentry/sentry-cli --auth-token $SENTRY_AUTH_TOKEN upload-dif -t dsym --org $SENTRY_ORG --project $SENTRY_PROJECT .
#docker run --rm -v $(pwd):/work getsentry/sentry-cli --auth-token $SENTRY_AUTH_TOKEN upload-dsym --org $SENTRY_ORG --project $SENTRY_PROJECT dsymsBeta
#docker run --rm -v $(pwd):/work getsentry/sentry-cli --auth-token $SENTRY_AUTH_TOKEN upload-dsym --org $SENTRY_ORG --project $SENTRY_PROJECT dsymsProd