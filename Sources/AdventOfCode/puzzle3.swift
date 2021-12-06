import Foundation

//  Solution for part 1: 2583164
//  Solution for part 2: 2784375

struct Puzzle3 {
    static let testData = [
        "00100",
        "11110",
        "10110",
        "10111",
        "10101",
        "01111",
        "00111",
        "11100",
        "10000",
        "11001",
        "00010",
        "01010"
    ]

    static func run() {
        // let data = testData
        let data = readFile(named: "puzzle3.txt")

        let puzzle = Puzzle3()

        print("Solution for part 1: \(puzzle.part1(data))")
        print("Solution for part 2: \(puzzle.part2(data))")
    }

    private func bitcounts(for data: [String]) -> [Int] {
        var bitcounts = [Int](repeating: 0, count: data[0].count)
        for str in data {
            for (index, digit) in str.enumerated() {
                if digit == "1" {
                    bitcounts[index] += 1
                }
            }
        }

        return bitcounts
    }

    func part1(_ data: [String]) -> Int {
        let bitcounts = self.bitcounts(for: data)
        let measurements = data.count
        let timer = Timer(day: 3); defer { timer.show() }
        var gamma = ""
        var epsilon = ""
        for index in 0..<bitcounts.count {
            let count = bitcounts[index]
            if count > measurements / 2 {
                gamma.append("1")
                epsilon.append("0")
            } else {
                gamma.append("0")
                epsilon.append("1")
            }
        }

        return Int(gamma, radix: 2)! * Int(epsilon, radix: 2)!
    }

    func part2(_ data: [String]) -> Int {
        let timer = Timer(day: 3); defer { timer.show() }
        let bitcounts = bitcounts(for: data)
        let oxygenRating = findRating(bitcounts, data: data, criterium: .mostCommon)
        let co2Rating = findRating(bitcounts, data: data, criterium: .leastCommon)
        return oxygenRating * co2Rating
    }

    enum BitCriterium {
        case mostCommon
        case leastCommon

        var majorityBit: String {
            switch self {
            case .mostCommon: return "1"
            case .leastCommon: return "0"
            }
        }

        var minorityBit: String {
            switch self {
            case .mostCommon: return "0"
            case .leastCommon: return "1"
            }
        }
    }

    func findRating(_ bitcounts: [Int], data: [String], criterium: BitCriterium) -> Int {
        var data = data
        var bitcounts = bitcounts
        var prefix = ""
        for index in 0..<bitcounts.count {
            let count = bitcounts[index]
            // print("index \(index), count \(count)")
            if Float(count) >= Float(data.count) / 2 {
                prefix.append(criterium.majorityBit)
            } else {
                prefix.append(criterium.minorityBit)
            }
            data = data.filter { $0.hasPrefix(prefix) }
            bitcounts = self.bitcounts(for: data)
            // print("index \(index), prefix \(prefix), data \(data)")
            if data.count == 1 {
                return Int(data[0], radix: 2)!
            }
        }

        fatalError()
    }
}
