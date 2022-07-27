#!/bin/bash

base="2022/05/"
olddate=""

for i in {1..31}
do
    day=""

    if (($i <= 10))
    then
    day+="0"
    fi

    day+=$i
    date="$base$day"

    if [ ! -z "$olddate" ]
    then
        let yesterday=$i-1
        yesterday="time.May, $yesterday"
        today="time.May, $i"
        
        # Update the dates in files
        sed -i -e "s|$olddate|$date|g" ~/config/configs/canada-test/config.go
        sed -i -e "s|$olddate|$date|g" ~/data-processing/xmode-import/service/src/main.go
        sed -i -e "s|$yesterday|$today|g" ~/data-processing/visits-processing/service/src/main.go
    fi

    # Run data processing
    (cd ~/data-processing/xmode-import/service/dev && make run CONFIG=canada-test)
    (cd ~/data-processing/visits-processing/service/dev && make run CONFIG=canada-test)

    # Prepare for next day
    olddate=$date
done
