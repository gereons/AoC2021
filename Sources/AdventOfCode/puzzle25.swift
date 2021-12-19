import Foundation

struct Puzzle25 {
    static let testData = [ "" ]

    static func run() {
        let data = readFile(named: "puzzle25.txt")

        let puzzle = Puzzle25()

        print("Solution for part 1: \(puzzle.part1(data))")
        print("Solution for part 2: \(puzzle.part2(data))")
    }

    private func part1(_ data: [String]) -> Int {
        let timer = Timer(day: 25); defer { timer.show() }
        return 42
    }

    private func part2(_ data: [String]) -> Int {
        let timer = Timer(day: 25); defer { timer.show() }
        return 42
    }
}
