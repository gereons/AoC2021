//
// Advent of Code 2021 Day 3
//

import AoCTools


final class Day03: AdventOfCodeDay {
    let title = "Binary Diagnostic"

    let lines: [String]

    init(input: String) {
        lines = input.lines
    }

    func part1() -> Int {
        let bitcounts = self.bitcounts(for: lines)
        let measurements = lines.count
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

    func part2() -> Int {
        let bitcounts = bitcounts(for: lines)
        let oxygenRating = findRating(bitcounts, data: lines, criterium: .mostCommon)
        let co2Rating = findRating(bitcounts, data: lines, criterium: .leastCommon)
        return oxygenRating * co2Rating
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
