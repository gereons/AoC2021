import Foundation

// Solution for part 1: 358214
// Solution for part 2: 1622533344325

struct Puzzle6 {
    static let testData = [ "3,4,3,1,2" ]

    static func run() {
        // let data = testData
        let data = readFile(named: "puzzle6.txt")

        let initialPopulation = Timer.time(day: 6) {
            data[0].split(separator: ",").compactMap { Int(String($0)) }
        }

        let puzzle = Puzzle6()

        print("Solution for part 1: \(puzzle.part1(initialPopulation))")
        print("Solution for part 2: \(puzzle.part2(initialPopulation))")
    }

    private func part1(_ initialPopulation: [Int]) -> Int {
        let timer = Timer(day: 6); defer { timer.show() }
        return growFish(from: initialPopulation, days: 80)
    }

    private func part2(_ initialPopulation: [Int]) -> Int {
        let timer = Timer(day: 6); defer { timer.show() }
        return growFish(from: initialPopulation, days: 256)
    }

    private func growFish(from initialPopulation: [Int], days: Int) -> Int {
        // index: age, content: count of fish with that age
        var today = [Int](repeating: 0, count: 9)
        for age in initialPopulation {
            today[age] += 1
        }

        for _ in 0..<days {
            var tomorrow = [Int](repeating: 0, count: 9)

            for (age, count) in today.enumerated() {
                if age == 0 {
                    tomorrow[8] += count
                    tomorrow[6] += count
                } else {
                    tomorrow[age - 1] += count
                }
            }

            today = tomorrow
        }

        return today.reduce(0, +)
    }
}
