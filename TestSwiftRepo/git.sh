#!/bin/bash
comment="No comment"
while getopts ":c:t:" opt 
do
  case $opt in
    c)comment=$OPTARG
      echo "-c was triggered!" >&2
      ;;
    t)tag=$OPTARG
	  echo "-t was triggered!" >&2
	  ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      ;;
  esac
done

cd ..

git add .
git commit -m "$comment"
git push --set-upstream origin master
if [ -n "${tag}" ]; then
	git tag "$tag"
	git push --set-upstream origin "$tag"
fi
