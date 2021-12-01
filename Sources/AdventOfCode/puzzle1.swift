import Foundation

enum Puzzle1 {
    static let testData = [ 199, 200, 208, 210, 200, 207, 240, 269, 260, 263 ]

    static func run() {
        // let data = testData
        let data = readFile(named: "puzzle1.txt").compactMap { Int($0) }

        print("Solution for part 1: \(part1(data))")
        print("Solution for part 2: \(part2(data))")
    }

    static func part1(_ data: [Int]) -> Int {
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

    static func part2(_ data: [Int]) -> Int {
        var windowSums = [Int]()
        for index in 0..<data.count - 2 {
            let window = data[index..<index+3]
            let sum = window.reduce(0, +)
            windowSums.append(sum)
        }

        return part1(windowSums)
    }
}
