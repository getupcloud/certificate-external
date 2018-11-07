#!/bin/bash

today_in_seconds=$(date +%s)
certificate_expire_date=$(echo | openssl s_client -connect ${ENDPOINT}:443 2>/dev/null | openssl x509 -noout -dates| grep -i notAfter | cut -d= -f2 | tail -n1)
certificate_expire_date_in_seconds=$(date +%s --date="$certificate_expire_date")
daysleft=$(( (certificate_expire_date_in_seconds - today_in_seconds) / 86400))

if [ $daysleft -lt 1 ]; then
    text="${ENDPOINT} has expired in $certificate_expire_date, $daysleft days ago."
else
    text="${ENDPOINT} will expire in $certificate_expire_date, $daysleft days left to go."
fi

echo $text

if [ $daysleft -le 60 ]
then
    echo alerting...
    webhook_url='${WEBHOOK_URL}'
    channel='${CHANNEL}'
    json="{\"channel\": \"${CHANNEL}\", \"username\":\"certificates\", \"icon_emoji\":\":scream_cat:\", \"attachments\":[{\"color\":\"danger\" , \"text\": \"$text\"}]}"
    curl -X POST --data-urlencode  "payload=$json" "$webhook_url"
fi
