//
// Advent of Code 2021 Day 8
//

import AoCTools

private struct Entry {
    let inputs: [String]
    let outputs: [String]

    init(_ str: String) {
        let s = str.split(separator: "|")
        let inputs = s[0].split(separator: " ").map { String(String($0).sorted()) }
        self.inputs = inputs.sorted { i1, i2 in
            if i1.count != i2.count {
                return i1.count < i2.count
            }
            return i1 < i2
        }
        outputs = s[1].split(separator: " ").map { String(String($0).sorted()) }
        assert(inputs.count == 10)
        assert(outputs.count == 4)
    }
}

final class Day08: AdventOfCodeDay {
    let title = "Seven Segment Search"

    private let entries: [Entry]

    init(input: String) {
        entries = input.lines.map { Entry($0) }
    }

    func part1() -> Int {
        var sum = 0
        for entry in entries {
            for out in entry.outputs {
                switch out.count {
                case 2,3,4,7: sum += 1
                default: ()
                }
            }
        }
        return sum
    }

    func part2() -> Int {
        entries.reduce(0) { sum, entry in
            sum + decode(entry)
        }
    }

    private func decode(_ entry: Entry) -> Int {
        var digits = [String: Int]()
        var found = [Bool](repeating: false, count: 10)

        // find the unique entries
        let one = entry.inputs[0]
        let seven = entry.inputs[1]
        let four = entry.inputs[2]
        let eight = entry.inputs[9]

        digits[one] = 1
        digits[seven] = 7
        digits[four] = 4
        digits[eight] = 8

        var fourcorner = four
        fourcorner.removeAll { $0 == one.first }
        fourcorner.removeAll { $0 == one.last }

        // find the 5-segment digits (3/5/2)
        let digit5 = entry.inputs[3...5]
        digit5.forEach { str in
            if !found[3] && str.containsAll(one) {
                digits[str] = 3
                found[3] = true
            } else if !found[5] && str.containsAll(fourcorner) {
                digits[str] = 5
                found[5] = true
            } else if !found[2] {
                digits[str] = 2
                found[2] = true
            }
        }

        // find the 6-segment digits (9/0/6)
        let digit6 = entry.inputs[6...8]
        digit6.forEach { str in
            if !found[9] && str.containsAll("\(four)\(seven)") {
                digits[str] = 9
                found[9] = true
            } else if !found[0] && str.containsAll(one) {
                digits[str] = 0
                found[0] = true
            } else if !found[6] {
                digits[str] = 6
                found[6] = true
            }
        }
        assert(digits.count == 10)

        // now match the 4 outputs to 4 digits
        return entry.outputs.reduce(0) { sum, output in
            sum * 10 + digits[output]!
        }
    }
}

private extension String {
    func containsAll(_ string: String) -> Bool {
        let lookupChars = Set(string.map { $0 })
        return lookupChars.isSubset(of: self)
    }
}
