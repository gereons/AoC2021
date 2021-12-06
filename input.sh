#!/bin/sh

DAY=$1

if [ -z "$DAY" ]; then
    echo "usage: $0 DAY" >&2
    exit 1
fi

curl https://adventofcode.com/2021/day/$DAY/input --cookie "session=$AOC_SESSION" >Fixtures/puzzle$DAY.txt
