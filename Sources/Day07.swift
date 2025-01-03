//
// Advent of Code 2021 Day 7
//

import AoCTools
import Foundation

final class Day07: AdventOfCodeDay {
    let title = "The Treachery of Whales"

    let positions: [Int]

    init(input: String) {
        positions = input.integers()
    }

    func part1() -> Int {
        let positions = positions.sorted(by: <)
        let target = positions.median()
        // cost: 1 fuel per distance
        return fuelConsumption(from: positions, to: target, cost: { $0 })
    }

    func part2() -> Int {
        // cost: 1,2,3,4,... increasing by distance
        let cost = { n in n * (n + 1) / 2 }

        let avg = Float(positions.reduce(0, +)) / Float(positions.count)

        let fuel1 = fuelConsumption(from: positions, to: Int(floor(avg)), cost: cost)
        let fuel2 = fuelConsumption(from: positions, to: Int(ceil(avg)), cost: cost)

        return min(fuel1, fuel2)
    }

    private func fuelConsumption(from positions: [Int], to target: Int, cost: (Int) -> Int) -> Int {
        return positions.reduce(0) { sum, position in
            sum + cost(abs(target - position))
        }
    }
}
