#!/bin/bash

function get_deets() {
    local _html
    _html="$(wget -q -O - "https://www.instagram.com/$1" | grep -o -P 'sharedData = .*</script>' )"
    echo "$_html"
}

function digest_json() {
    # "biography":"
    local _bio
    _bio="$( echo -n "$1" | grep -o -P '"biography":".*?"' | grep -oP ':.*' | grep -oP '[^"]*"\K[^"]*' )"
    
    # "edge_followed_by":{"count":###}
    local _followers
    _followers="$( echo -n "$1" | grep -o -P '"edge_followed_by":.*?}' | grep -oP '\d*')"
    
    # "edge_follow":{"count":###}
    local _following
    _following="$( echo -n "$1" | grep -o -P '"edge_follow":.*?}' | grep -oP '\d*')"
    
    # "full_name":"
    local _fullname
    _fullname="$( echo -n "$1" | grep -o -P '"full_name":".*?"' | grep -oP ':.*' | grep -oP '[^"]*"\K[^"]*' )"
    
    # "highlight_reel_count":###
    local _highlight_reel
    _highlight_reel="$( echo -n "$1" | grep -o -P '"highlight_reel_count":\d*[,}]+' | grep -oP '\d*')"
    
    # "profile_pic_url_hd":"
    local _profile_pic
    _profile_pic="$( echo -n "$1" | grep -o -P '"profile_pic_url_hd":".*?"' | grep -oP ':.*' | grep -oP '[^"]*"\K[^"]*' )"
    
    # "edge_owner_to_timeline_media":{"count":582
    local _posts
    _posts="$( echo -n "$1" | grep -o -P '"edge_owner_to_timeline_media":.*?[,}]+' | grep -oP '\d*')"
    
    local str_hash
    str_hash=$( echo -n "$_bio $_fullname $_profile_pic" | md5sum | awk '{ print $1 }' )
    echo "posts:$_posts followers:$_followers following:$_following reel:$_highlight_reel md5str:$str_hash"
}

function get_hash() {
    local _html
    _html="$( digest_json "$1" )"

    #-- return MD5
    echo -n "$_html" | md5sum | awk '{ print $1 }'
}

function download_profile_pic() {
    #-- To Do
    # "profile_pic_url_hd":"
    local _profile_pic
    _profile_pic="$( echo -n "$2" | grep -o -P '"profile_pic_url_hd":".*?"' | grep -oP ':.*' | grep -oP '[^"]*"\K[^"]*' )"
    
    wget -q -O "$1-$( date +%Y%m%d%H%M%S ).jpg" "$( echo -e "$_profile_pic")"

}

function archive_org {
    #-- Does not work
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
echo -n ""
while true; do
    #-- Compare hashes
    hash="$( get_hash "$html" )"
    if [ "$hash" != "$last_hash" ]; then
        focus_on_me=30
        last_hash="$hash"
        echo ""
        echo "UPDATE: $profile's profile changed ($( date +%Y%m%d-%H%M%S ))"
        digest_json "$html"

        {
            date
            echo "$html"
            echo ""
        } >> "$profile.txt"

        download_profile_pic "$profile" "$html"
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
        echo -ne "\runchanged, waiting... (last check: $( date "%H%M%S" ))"
        sleep "$(( 60 * 5 ))"  #-- 5 mins
    fi

    #-- Get fresh copy of profile page
    html="$( get_deets "$profile" )"
done
