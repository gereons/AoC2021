import Foundation

struct Puzzle14 {
    let testData = [ "" ]

    static func run() {
        let data = readFile(named: "puzzle14.txt")

        let puzzle = Puzzle14()

        print("Solution for part 1: \(puzzle.part1(data))")
        print("Solution for part 2: \(puzzle.part2(data))")
    }

    private func part1(_ data: [String]) -> Int {
        return 42
    }

    private func part2(_ data: [String]) -> Int {
        return 42
    }
}
