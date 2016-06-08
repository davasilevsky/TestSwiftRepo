#!/bin/bash

_project=$1
_branch=$2
_circle_token=$3

trigger_build_url=https://circleci.com/api/v1/project/davasilevsky/TestSwiftRepo/tree/master?circle-token=2496c94f6b3235af82af9e1ea192ed71d3539acb

post_data=$(cat <<EOF
{
  "build_parameters": {
    "IS_NIGHTLY_BUILD": "true"
  }
}
EOF)

curl \
--header "Accept: application/json" \
--header "Content-Type: application/json" \
--data "${post_data}" \
--request POST ${trigger_build_url}
