import Foundation

struct Puzzle20 {
    static let testData = [ "" ]

    static func run() {
        let data = readFile(named: "puzzle20.txt")

        let puzzle = Puzzle20()

        print("Solution for part 1: \(puzzle.part1(data))")
        print("Solution for part 2: \(puzzle.part2(data))")
    }

    private func part1(_ data: [String]) -> Int {
        let timer = Timer(day: 20); defer { timer.show() }
        return 42
    }

    private func part2(_ data: [String]) -> Int {
        let timer = Timer(day: 20); defer { timer.show() }
        return 42
    }
}
