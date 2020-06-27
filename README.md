# ig-monitor
A bash script that monitors a single instagram account for changes.

# install (git)
```sh
git clone https://github.com/lord-aceldama/ig-monitor.git
cd ig-monitor
chmod +x igmonitor.sh
```

# install (wget)
```sh
mkdir ig-monitor
cd ig-monitor
wget -O ig-monitor.sh "https://raw.githubusercontent.com/lord-aceldama/ig-monitor/master/ig-monitor.sh"
chmod +x ig-monitor.sh
```

# usage
replace `profilename` with the account name you wish to monitor. do not use `@profilename`.
```sh
./ig-monitor.sh profilename
```

# checking for changes
to check for any changes, check the ig-profilename.txt file.
```sh
cat profilename.txt
```
a copy of the user's profile pic can also be found in the same directory. the format for the image name is `profilename-YYYYMMDDhhmmss`, where the right-hand portion is a timestamp.

# future improvements
may check to see if i can monitor multiple profiles instead of just one.
