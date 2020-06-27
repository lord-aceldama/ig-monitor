# ig-monitor
A bash script that monitors a single instagram account for changes.

# usage
replace `profilename` with the account name you wish to monitor. do not use `@profilename`
```sh
bash ig-monitor profilename
```

# checking for changes
to check for any changes, check the ig-profilename.txt file.
```sh
cat ig-profilename.txt
```
a copy of the user's profile pic can also be found in the same directory. the format for the image name is `profilename-YYYYMMDDhhmmss`, where the right-hand portion is a timestamp.

# future improvements
may check to see if i can monitor multiple profiles instead of just one.
