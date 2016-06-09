#!/bin/sh

cd "$(dirname "$0")"
echo $PWD
plist=./TestSwiftRepo/Info.plist
dir="$(dirname "$plist")"

# Method to increment version by +1 to the last number of version
increment_version ()
{
  declare -a part=( ${1//\./ } )
  declare    new
  declare -i carry=1

  for (( CNTR=${#part[@]}-1; CNTR>=0; CNTR-=1 )); do
    len=${#part[CNTR]}
    new=$((part[CNTR]+carry))
    [ ${#new} -gt $len ] && carry=1 || carry=0
    [ $CNTR -gt 0 ] && part[CNTR]=${new: -len} || part[CNTR]=${new}
  done
  new="${part[*]}"
  echo "${new// /.}"
} 

# Only increment the build number if source files have changed
if [ -n "$(find "$dir" \! -path "*xcuserdata*" \! -path "*.git")" ]; then
    bundleVersion=$(/usr/libexec/Plistbuddy -c "Print CFBundleVersion" "$plist")
    if [ -z "$bundleVersion" ]; then
        echo "No build number in $plist"
        exit 2
    fi
    
    bundleVersion="$(increment_version $bundleVersion)"
    /usr/libexec/Plistbuddy -c "Set CFBundleVersion $bundleVersion" "$plist"
    /usr/libexec/Plistbuddy -c "Set CFBundleShortVersionString $bundleVersion" "$plist"
    echo "Incremented build number to $bundleVersion"

    sh ./git.sh -c "Incremented build number to $bundleVersion" -t "$bundleVersion"
else
    echo "Not incrementing build number as source files have not changed"
fi
