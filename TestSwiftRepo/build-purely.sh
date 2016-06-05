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

## Archiving                                                                    
echo "Archiving..."
xcodebuild -workspace ./TestSwiftRepo.xcworkspace -scheme TestSwiftRepo archive -archivePath ./TestSwiftRepo.xcarchive
## Creating ipa                                                                 
echo "Creating IPA file..."

xcodebuild  -exportArchive \
            -exportOptionsPlist ./exportOptions.plist \
            -archivePath ./TestSwiftRepo.xcarchive \
            -exportPath ./TestSwiftRepo/Translate.ipa

# sh ./Nitro/etc/testfairy-upload-ios.sh ./Nitro/etc/Translate.ipa/Translate.ipa
rm -rf ./TestSwiftRepo.xcarchive
# rm ./Nitro/etc/Translate.ipa/Translate.ipa
