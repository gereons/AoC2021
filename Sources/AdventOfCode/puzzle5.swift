import Foundation

struct Puzzle5 {
    let testData = [ "" ]

    static func run() {
        let data = readFile(named: "puzzle5.txt")

        let puzzle = Puzzle5()

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
