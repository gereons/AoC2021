import Foundation

// Solution for part 1: 356179
// Solution for part 2: 99788435

struct Puzzle7 {
    static let testData = [ "16,1,2,0,4,2,7,1,2,14" ]

    static func run() {
        // let data = testData
        let data = readFile(named: "puzzle7.txt")

        let positions = Timer.time(day: 7) {
            data[0].split(separator: ",").compactMap { Int(String($0)) }
        }

        let puzzle = Puzzle7()

        print("Solution for part 1: \(puzzle.part1(positions))")
        print("Solution for part 2: \(puzzle.part2(positions))")
    }

    private func part1(_ positions: [Int]) -> Int {
        let timer = Timer(day: 7); defer { timer.show() }
        // cost: 1 fuel per distance
        return minimumFuel(positions, cost: { $0 })
    }

    private func part2(_ positions: [Int]) -> Int {
        let timer = Timer(day: 7); defer { timer.show() }
        // cost: 1,2,3,4,... increasing by distance
        return minimumFuel(positions, cost: { $0 * ($0+1) / 2})
    }

    private func minimumFuel(_ positions: [Int], cost: (Int)->Int) -> Int {
        var minFuel = Int.max
        for target in positions {
            var fuel = 0
            for position in positions {
                fuel += cost(abs(target - position))
            }
            minFuel = Swift.min(minFuel, fuel)
        }

        return minFuel
    }
}
