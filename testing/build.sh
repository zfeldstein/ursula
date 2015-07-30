#!/bin/bash

export SHORT_SHA=$(echo $GIT_COMMIT | awk '{print substr($0,0,8)}')

heat stack-create -f testing/heat/test-standard.yml -P "key_name=$KEY_NAME;image=$GLANCE_IMAGE;flavor=$FLAVOR_ID;net_id=$NETWORK_ID" "ursula-$GLANCE_IMAGE-$SHORT_SHA"
