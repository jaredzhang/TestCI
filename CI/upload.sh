#!/bin/sh

# The script exits immediately if any statement or command returns non-true value
set -e

if [ "$TRAVIS_PULL_REQUEST" != "false" ]; then
  echo "This is a pull request. No deployment."
  exit 0
fi
if [ "$TRAVIS_BRANCH" != "master" && "$TRAVIS_BRANCH" != "test" ]; then
  echo "Building on a branch other than master and test. No deployment."
  exit 0
fi
if [ "$TRAVIS_REPO_SLUG" != "$REPO_SLUG" ]; then
  echo "It's not the main repo. No deployment."
fi

if [ "$TRAVIS_BRANCH" == "master" ]; then
  APP_ID="261"
  PROFILE_NAME="InHouseWildcard"
fi

OUTPUTDIR="$PWD/app/build/outputs/apk"

echo "$OUTPUTDIR"

BUILD_NUMBER= $TRAVIS_BUILD_NUMBER
VERSION_NUMBER= $TRAVIS_BUILD_NUMBER
#VERSION="$VERSION_NUMBER ($BUILD_NUMBER) #$TRAVIS_BUILD_NUMBER"
VERSION="#$TRAVIS_BUILD_NUMBER"

DESCRIPTION=`git log --format=%B -n 1 HEAD`

if [ ! -z "$APP_MANAGER_API_TOKEN" ]; then
  echo ""
  echo "************************************************************************"
  echo "*             Uploading to 2359 Media Enterprise App Manager           *"
  echo "************************************************************************"
  curl https://app.2359media.net/api/v1/apps/$APP_ID/versions \
    -F binary="@$OUTPUTDIR/app-debug.apk" \
    -F api_token="$APP_MANAGER_API_TOKEN" \
    -F platform="android" \
    -F version_number="$VERSION" \
    -F description="$DESCRIPTION" \
    -F email_list="jesse.armand@2359media.com,zhuodong.zhang@2359media.com>"
fi

echo "\n"