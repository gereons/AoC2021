//
// Advent of Code 2021 Day 17
//

import AoCTools

final class Day17: AdventOfCodeDay {
    let title = "Trick Shot"

    struct Target {
        let xRange: ClosedRange<Int>
        let yRange: ClosedRange<Int>
    }

    let target: Target

    init(input: String) {
        let ints = input.integers()
        target = Target(xRange: ints[0]...ints[1], yRange: ints[2]...ints[3])
    }

    func part1() -> Int {
        part1and2().0
    }

    func part2() -> Int {
        part1and2().1
    }

    private func part1and2() -> (Int, Int) {
        var maxApex = 0
        var velocities = 0
        for dx in 1...target.xRange.upperBound {
            for dy in target.yRange.lowerBound ... -target.yRange.lowerBound {
                if let apex = launchProbe(dx: dx, dy: dy, at: target) {
                    maxApex = max(maxApex, apex)
                    velocities += 1
                }
            }
        }

        return (maxApex, velocities)
    }

    // if target hit, return apex, else nil
    private func launchProbe(dx: Int, dy: Int, at target: Target) -> Int? {
        var x = 0
        var y = 0
        var vx = dx
        var vy = dy

        while x < target.xRange.upperBound && y > target.yRange.lowerBound {
            x += vx
            y += vy
            if vx > 0 {
                vx -= 1
            }
            vy -= 1

            if target.xRange ~= x && target.yRange ~= y {
                return dy * (dy + 1) / 2
            }
        }
        return nil
    }
}
