//
// Advent of Code 2021 Day 1
//

import AoCTools

final class Day01: AdventOfCodeDay {
    let title = "Sonar Sweep"

    let sonarData: [Int]

    init(input: String) {
        sonarData = input.lines.map { Int($0)! }
    }

    func part1() -> Int {
        return sumIfGreater(sonarData)
    }

    func part2() -> Int {
        var windowSums = [Int]()
        for index in 0..<sonarData.count - 2 {
            let window = sonarData[index..<index+3]
            let sum = window.reduce(0, +)
            windowSums.append(sum)
        }

        return sumIfGreater(windowSums)
    }

    private func sumIfGreater(_ data: [Int]) -> Int {
        var increments = 0
        var previousDepth: Int? = nil

        for depth in data {
            if let prev = previousDepth, depth > prev {
                increments += 1
            }
            previousDepth = depth
        }

        return increments
    }
}
