#!/bin/bash

export SHORT_SHA=$(echo $GIT_COMMIT | awk '{print substr($0,0,8)}')

if [[ "$CI" == "jenkins" ]]; then
    VENV=$WORKSPACE/venv
    virtualenv $VENV
    source $VENV/bin/activate
    pip install -U -r requirements.txt
fi

heat stack-create -f testing/heat/test-standard.yml -P "key_name=$KEY_NAME;image=$GLANCE_IMAGE;flavor=$FLAVOR_ID;net_id=$NETWORK_ID" "ursula-$GLANCE_IMAGE-$SHORT_SHA"
