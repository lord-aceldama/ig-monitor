# ig-monitor
A bash script that monitors a single instagram account for changes and submits it to archive.org if a change occurs.

# usage
replace `profilename` with the account name you wish to monitor. do not use `@profilename`
```sh
bash ig-monitor profilename
```

# checking archive.org for changes
to check archive.org for any changes, just use the following url, replacing `profilename` with the profile name you're monitoring.
```sh
https://web.archive.org/web/*/https://www.instagram.com/profilename/
```

# future improvements
may check to see if i can monitor multiple profiles instead of just one. also look into saving profile images or html to a file.
