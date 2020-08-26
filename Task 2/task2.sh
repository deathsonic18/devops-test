#!/bin/bash

day=$(date)
echo "Script running $day"

user=melitatest082020
one_day=$(date -d 'now - 1 day' +%s)
seven_days=$(date -d 'now - 7 days' +%s)
file_time=$(date -r "$filename" +%s)
one_day_path_location=/home/$user/ftpuser
seven_day_path_location=/home/$user/ftpuser

declare -A levels=([DEBUG]=0 [INFO]=1 [WARN]=2 [ERROR]=3)
logging_levels="INFO"

logging() {
                #checks 'if' statements has errors
                # logs any errrors
                local first_check=$1
                local second_check=$2

#check if directory exists
if [ -d $one_day_path_location ]; then
        echo "Directory doesn't exists" ;
else
        mkdir -p "$one_day_path_location";
        (( ${levels[$second_check]} < ${levels[$logging_levels]} )) && return 2
        echo "$one_day_path_location directory is created" [[ ${levels[$second_check]} ]] || return 1
fi
if [ -d $seven_day_path_location ]; then
        echo "Directory doesn't exists" ;
else
        (( ${levels[$second_check]} < ${levels[$logging_levels]} )) && return 2
        mkdir -p "$seven_day_path_location";
        echo "$seven_day_path_location directory is created" [[ ${levels[$second_check]} ]] || return 1
fi
#checks if files are older than 1 day
if (( file_time <= one_day )); then
  echo "$filename is older than 1 day"
  find $one_day_path_location  -type f -name '*.csv' -exec cp /home/ftpuser/ /mnt/transfer/ \{\} \; [[ ${levels[$second_check]} ]] || return 1
else
        (( ${levels[$second_check]} < ${levels[$logging_levels]} )) && return 2
        echo "No new .csv files found in $one_day"
        echo "Inside path $one_day_path_location"
fi
#checks if files are older than 7 days
if (( file_time <= seven_days )); then
  echo "$filename is older than 7 days"
  find $one_day_path_location  -type f -name '*.csv' -exec tar -czf $filename /mnt/archive/ \{\} \; [[ ${levels[$second_check]} ]] || return 1
else
        (( ${levels[$second_check]} < ${levels[$logging_levels]} )) && return 2
        echo "No new .csv files found in $seven_days"
        echo "Inside path $seven_day_path_location"
fi
#shows error message
echo "${second_check} : ${first_check}"
}
logging "WARN"
logging "DEBUG"
logging "ERROR"

