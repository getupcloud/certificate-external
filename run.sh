#!/bin/bash

    today=`date +%D`
    expiredate=`echo | openssl s_client -connect ${ENDPOINT}:443 2>/dev/null | openssl x509 -noout -dates| cut -d '=' -f2 | tail -n1`
    expdate="date +%D --date='$expiredate'"
    ed=`eval $expdate`
    daysleft=`echo $(($(($(date -u -d "$ed" "+%s") - $(date -u -d "$today" "+%s"))) / 86400))`
    text="${ENDPOINT} - expiring on: $ed , $daysleft days left to go."
    echo $expiredate

    if [ $daysleft -le 60 ]
    then
          webhook_url='${WEBHOOK_URL}'
          channel='${CHANNEL}'
          json="{\"channel\": \"${CHANNEL}\", \"username\":\"certificates\", \"icon_emoji\":\":scream_cat:\", \"attachments\":[{\"color\":\"danger\" , \"text\": \"$text\"}]}"
          curl -X POST --data-urlencode  "payload=$json" "$WEBHOOK_URL"
    fi

