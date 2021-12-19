import Foundation

struct Puzzle21 {
    static let testData = [ "" ]

    static func run() {
        let data = readFile(named: "puzzle21.txt")

        let puzzle = Puzzle21()

        print("Solution for part 1: \(puzzle.part1(data))")
        print("Solution for part 2: \(puzzle.part2(data))")
    }

    private func part1(_ data: [String]) -> Int {
        let timer = Timer(day: 21); defer { timer.show() }
        return 42
    }

    private func part2(_ data: [String]) -> Int {
        let timer = Timer(day: 21); defer { timer.show() }
        return 42
    }
}
