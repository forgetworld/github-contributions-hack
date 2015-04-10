#!/bin/bash

COMMAND=date
if [[ `uname` == "Darwin" ]]; then
	COMMAND=gdate
fi

start=`$COMMAND -d -30days +%Y-%m-%d`
days=30
commits=5
author=`git config user.email`

ARGS=`getopt -o a: --long start:,days:,commits:,author: -- "$@"`

eval set -- "${ARGS}"
unset ARGS
while true
do
    case "$1" in
        --start)
            start=$2;
            shift 2
            ;;
        --days)
            days=$2;
            shift 2
            ;;
        --commits)
            commits=$2;
            shift 2
            ;;
        --author)
            author=$2;
            shift 2
            ;;
        --)
            shift
            break
            ;;
        *)
            echo "未知参数 $1 !"
            exit 1
            ;;
    esac
done

if ! [ -d dates ]; then
	mkdir ./dates
fi

for d in $( seq 1 $days )
do
	day=`$COMMAND -d "$start +${d}days" +%Y-%m-%d`
	rand=`echo $RANDOM`
	rand=$(($rand%$commits+1))
	echo "$day $rand"

	for r in $( seq 1 $rand )
	do
		filename="dates/${day}-${r}"
		touch $filename
		git add "$filename"
		git commit --date="$day 14:00:00 +0800" --author="$author" -m "$filename"
	done
done
