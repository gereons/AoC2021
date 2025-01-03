//
// Advent of Code 2021 Day 10
//

import AoCTools

final class Day10: AdventOfCodeDay {
    let title = "Syntax Scoring"

    let lines: [String]

    init(input: String) {
        lines = input.lines
    }

    func part1() -> Int {
        return lines.reduce(0) { sum, line in
            sum + errorScore(for: line).0
        }
    }

    func part2() -> Int {
        var scores = [Int]()
        for line in lines {
            let (score, expected) = errorScore(for: line)
            if score != 0 {
                continue
            }

            let incompleteScore = expected.reduce(0) { sum, ch in
                sum * 5 + ch.incompleteScore
            }
            scores.append(incompleteScore)
        }
        return scores.sorted(by: <)[scores.count / 2]
    }

    private func errorScore(for line: String) -> (Int, [Character])  {
        var expected = [Character]()
        for ch in line {
            if ch.isOpenParen {
                expected.insert(ch.closingParen(), at: 0)
            } else {
                if ch == expected[0] {
                    expected.remove(at: 0)
                } else {
                    // print("expected \(expected[0]) but saw \(ch)")
                    return (ch.errorScore, expected)
                }
            }
        }
        // incomplete
        return (0, expected)
    }
}

private extension Character {
    var isOpenParen: Bool {
        self == "(" || self == "{" || self == "[" || self == "<"
    }

    func closingParen() -> Character {
        switch self {
        case "(": ")"
        case "{": "}"
        case "[": "]"
        case "<": ">"
        default: fatalError()
        }
    }

    var errorScore: Int {
        switch self {
        case ")": 3
        case "]": 57
        case "}": 1197
        case ">": 25137
        default: fatalError()
        }
    }

    var incompleteScore: Int {
        switch self {
        case ")": 1
        case "]": 2
        case "}": 3
        case ">": 4
        default: fatalError()
        }
    }
}
