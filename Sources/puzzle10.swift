import Foundation

struct Puzzle10 {
    static let testData = [
        //"([])", "{()()()}", "<([{}])>", "[<>({}){}[([])<>]]", "(((((((((())))))))))",
        "[({(<(())[]>[[{[]{<()<>>",
        "[(()[<>])]({[<{<<[]>>(",
        "{([(<{}[<>[]}>{[]{[(<()>",
        "(((({<>}<{<{<>}{[]{[]{}",
        "[[<[([]))<([[{}[[()]]]",
        "[{[{({}]{}}([{[{{{}}([]",
        "{<[[]]>}<{[{[{[]{()[[[]",
        "[<(<(<(<{}))><([]([]()",
        "<{([([[(<>()){}]>(<<{{",
        "<{([{{}}[<[[[<>{}]]]>[]]"
    ]

    static func run() {
        // let data = testData
        let data = Self.rawInput.components(separatedBy: "\n")

        let puzzle = Puzzle10()

        print("Solution for part 1: \(puzzle.part1(data))")
        print("Solution for part 2: \(puzzle.part2(data))")
    }

    private func part1(_ data: [String]) -> Int {
        let timer = Timer(day: 10); defer { timer.show() }
        return data.reduce(0) { sum, line in
            sum + errorScore(for: line).0
        }
    }

    private func part2(_ data: [String]) -> Int {
        let timer = Timer(day: 10); defer { timer.show() }
        var scores = [Int]()
        for line in data {
            let (score, expected) = errorScore(for: line)
            if score != 0 { continue }

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
        case "(": return ")"
        case "{": return "}"
        case "[": return "]"
        case "<": return ">"
        default: fatalError()
        }
    }

    var errorScore: Int {
        switch self {
        case ")": return 3
        case "]": return 57
        case "}": return 1197
        case ">": return 25137
        default: fatalError()
        }
    }

    var incompleteScore: Int {
        switch self {
        case ")": return 1
        case "]": return 2
        case "}": return 3
        case ">": return 4
        default: fatalError()
        }
    }
}
