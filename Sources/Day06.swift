//
// Advent of Code 2021 Day 6
//

import AoCTools

final class Day06: AdventOfCodeDay {
    let title = "Lanternfish"

    let initialPopulation: [Int]

    init(input: String) {
        initialPopulation = input.integers()
    }

    func part1() -> Int {
        growFish(from: initialPopulation, days: 80)
    }

    func part2() -> Int {
        growFish(from: initialPopulation, days: 256)
    }

    private func growFish(from initialPopulation: [Int], days: Int) -> Int {
        // index: age, value: count of fish with that age
        var school = [Int](repeating: 0, count: 9)
        for age in initialPopulation {
            school[age] += 1
        }

        for _ in 0..<days {
            let new = school[0]
            school[0] = school[1]
            school[1] = school[2]
            school[2] = school[3]
            school[3] = school[4]
            school[4] = school[5]
            school[5] = school[6]
            school[6] = school[7] + new
            school[7] = school[8]
            school[8] = new
        }

        return school.reduce(0, +)
    }
}
