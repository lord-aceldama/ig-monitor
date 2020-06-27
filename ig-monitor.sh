#!/bin/bash

function get_deets() {
    html="$(wget -q -O - "https://www.instagram.com/$1" | grep -o -P 'sharedData = .*</script>' )"

    if echo -n "$html" | grep -q "nonce"; then
        html="$( echo -n "$html" | grep -o -P '"viewer.*nonce"' )"
    fi
    if echo -n "$html" | grep -q '"has_next_page":true'; then
        html="$( echo -n "$html" | grep -o -P '"viewer.*has_next_page":true' )"
    fi

    echo "$html"
}


#-- Init
profile="$1"
html="$( get_deets "$profile" )"
last_hash="$( echo -n "$html" | md5sum )"
focus_on_me=0

#-- Monitor loop
while true; do
    #-- Compare hashes
    hash="$( echo -n "$html" | md5sum )"
    if [ "$hash" != "$last_hash" ]; then
        echo "changed: submitting to iwbm..."
        wget -q -O - "https://web.archive.org/save/https://www.instagram.com/$profile/"
        echo done!
        focus_on_me=30
    else
        echo "unchanged, waiting..."
    fi

    #-- Flood protection delay
    if [ $focus_on_me -gt 0 ]; then
        sleep 20 #-- wait 20 seconds
    else
        sleep "$(( 60 * 5 ))"  #-- 5 mins
    fi

    #-- Get fresh copy of profile page
    html="$( get_deets "$profile" )"
done
