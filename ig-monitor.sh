#!/bin/bash

function get_deets() {
    local html="$(wget -q -O - "https://www.instagram.com/$1" | grep -o -P 'sharedData = .*</script>' )"
    echo "$html"
}

function digest_json() {
    #-- To Do
    local html="$1"

    #-- strip random strings
    if echo -n "$html" | grep -q "nonce"; then
        html="$( echo -n "$html" | grep -o -P '"viewer.*nonce"' )"
    fi
    if echo -n "$html" | grep -q '"has_next_page":true'; then
        html="$( echo -n "$html" | grep -o -P '"viewer.*has_next_page":true' )"
    fi

    echo "$html"
}

function get_hash() {
    local html="$( digest_json "$1" )"

    #-- return MD5
    echo -n "$html" | md5sum
}

function archive_org {
    echo "submitting to archive.org..."
    wget -q -O - "https://web.archive.org/save/https://www.instagram.com/$profile/"
    echo done!
}


#-- Init
profile="$1"
html="$( get_deets "$profile" )"
last_hash="" #"$( $get_hash "$html" )"
focus_on_me=0

#-- Monitor loop
while true; do
    #-- Compare hashes
    hash="$( get_hash "$html" )"
    if [ "$hash" != "$last_hash" ]; then
        focus_on_me=30
        last_hash="$hash"
        echo "changed: $( date )"
        echo "$html" >> ig-changes.txt
        echo "$( digest_json "$html" )"
    fi

    #-- Flood delay
    if [[ $focus_on_me -gt 0 ]]; then
        echo -ne " \runchanged, focused...  ($focus_on_me)"
        focus_on_me=$(( focus_on_me - 1 ))
        sleep 10 #-- wait N seconds
        if [[ $focus_on_me -eq 0 ]]; then
            echo ""
        fi
    else
        echo "unchanged, waiting..."
        sleep "$(( 60 * 5 ))"  #-- 5 mins
    fi

    #-- Get fresh copy of profile page
    html="$( get_deets "$profile" )"
done
