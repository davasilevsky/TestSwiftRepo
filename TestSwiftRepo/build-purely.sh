#!/bin/bash

while getopts ":c:" opt
do
  case $opt in
    c)comment=$OPTARG
      echo "-c was triggered!" >&2
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      ;;
  esac
done

cd ./TestSwiftRepo

IS_NIGHTLY_LAUNCH=$1
echo "nightly flag is: $IS_NIGHTLY_LAUNCH"
if [ -n "${IS_NIGHTLY_LAUNCH}" ] && [ "$IS_NIGHTLY_LAUNCH" = true ]; then
  echo "NIGHTLY case"
else
  echo "MANUAL case"
fi

echo $PWD
# Here we launch script, incrementing a build version. On the way we'd like to
# retrieve the resulting version. Assuming the last thing the script does is
# 'echo'ing its result, we take the last line from 'echo' log and consider it
# as a build version we want. Fragile logic, but no risk is here either.
build_version="$(sh ./bump_build_number.sh 2>&1 | tail -1)"

## Archiving                                                                    
echo "Archiving..."
xcodebuild -workspace ./TestSwiftRepo.xcworkspace -scheme TestSwiftRepo archive -archivePath ./TestSwiftRepo.xcarchive
## Creating ipa                                                                 
echo "Creating IPA file..."

xcodebuild  -exportArchive \
            -exportOptionsPlist ./exportOptions.plist \
            -archivePath ./TestSwiftRepo.xcarchive \
            -exportPath ./TestSwiftRepo/TestSwiftRepo_ipa

sh ./testfairy-upload-ios.sh ./TestSwiftRepo/TestSwiftRepo_ipa/TestSwiftRepo.ipa
rm -rf ./TestSwiftRepo.xcarchive
rm ./TestSwiftRepo/TestSwiftRepo_ipa/TestSwiftRepo.ipa
