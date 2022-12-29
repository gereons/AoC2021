#!/bin/sh

YR=2021
DAY=$1

if [ -z "$DAY" ]; then
    DAY=$(date +%d)
fi

echo "getting puzzle input for day $DAY"

D2=$(printf "%02d" $DAY)

TMP=.input.$$.tmp

curl -s https://adventofcode.com/$YR/day/$DAY/input --cookie "session=$AOC_SESSION" >$TMP

(
cat <<END
//
// Advent of Code $YR - input for day $D2
//

extension Puzzle$DAY {
static let rawInput = #"""
END

cat $TMP

cat <<END
"""#
}
END
) >Sources/puzzle$DAY+input.swift

rm $TMP
