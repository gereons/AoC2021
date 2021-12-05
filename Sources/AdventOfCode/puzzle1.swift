import Foundation

// Solution for part 1: 1532
// Solution for part 2: 1571

struct Puzzle1 {
    static let testData = [ 199, 200, 208, 210, 200, 207, 240, 269, 260, 263 ]

    static func run() {
        // let data = Self.testData
        let data = readFile(named: "puzzle1.txt").compactMap { Int($0) }

        let puzzle = Puzzle1()

        print("Solution for part 1: \(puzzle.part1(data))")
        print("Solution for part 2: \(puzzle.part2(data))")
    }

    private func part1(_ data: [Int]) -> Int {
        let timer = Timer(day: 1); defer { timer.show() }
        return sumIfGreater(data)
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

    private func part2(_ data: [Int]) -> Int {
        let timer = Timer(day: 1); defer { timer.show() }
        var windowSums = [Int]()
        for index in 0..<data.count - 2 {
            let window = data[index..<index+3]
            let sum = window.reduce(0, +)
            windowSums.append(sum)
        }

        return sumIfGreater(windowSums)
    }
}
