#!/bin/sh

DAY=$1

if [ -z "$DAY" ]; then
    DAY=$(date +%d)
fi
echo "fetching input for day $DAY"

curl https://adventofcode.com/2021/day/$DAY/input --cookie "session=$AOC_SESSION" >Fixtures/puzzle$DAY.txt
