import Foundation

struct Puzzle11 {
    let testData = [ "" ]

    static func run() {
        let data = readFile(named: "puzzle11.txt")

        let puzzle = Puzzle11()

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
