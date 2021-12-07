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
        let positions = positions.sorted(by: <)
        let target = median(positions)
        // cost: 1 fuel per distance
        return fuelConsumption(from: positions, to: target, cost: { $0 })
    }

    private func part2(_ positions: [Int]) -> Int {
        let timer = Timer(day: 7); defer { timer.show() }
        // cost: 1,2,3,4,... increasing by distance
        let cost = { n in n * (n + 1) / 2 }

        let avg = positions.reduce(0, +) / positions.count

        let fuel1 = fuelConsumption(from: positions, to: avg, cost: cost)
        let fuel2 = fuelConsumption(from: positions, to: avg + 1, cost: cost)

        return min(fuel1, fuel2)
    }

    private func fuelConsumption(from positions: [Int], to target: Int, cost: (Int)->Int) -> Int {
        return positions.reduce(0) { sum, position in
            sum + cost(abs(target - position))
        }
    }

    private func median(_ values: [Int]) -> Int {
        if values.count.isMultiple(of: 2) {
            let v1 = values[values.count / 2]
            let v2 = values[values.count / 2 - 1]
            return (v1 + v2) / 2
        } else {
            return values[values.count / 2]
        }
    }
}
