import Foundation

struct Puzzle14 {
    static let testData = [
        "NNCB",
        "",
        "CH -> B",
        "HH -> N",
        "CB -> H",
        "NH -> C",
        "HB -> C",
        "HC -> B",
        "HN -> C",
        "NN -> C",
        "BH -> H",
        "NC -> B",
        "NB -> B",
        "BN -> B",
        "BB -> N",
        "BC -> B",
        "CC -> N",
        "CN -> C"
    ]

    struct Pair: Hashable {
        let a: Character
        let b: Character
    }

    static func run() {
        // let data = testData
        let data = Self.rawInput.components(separatedBy: "\n")

        // parse a rule like "AC -> B" as ["AC": ["AB", "BC"]]
        let (template, insertions) = Timer.time(day: 14) { () -> (String, [Pair: [Pair]]) in
            let template = data[0]

            var insertions = [Pair: [Pair]]()
            for line in data.dropFirst(2) {
                let tokens = line.split(separator: " ")
                let pair = Pair(a: tokens[0].first!, b: tokens[0].last!)
                let insert1 = Pair(a: tokens[0].first!, b: tokens[2].first!)
                let insert2 = Pair(a: tokens[2].first!, b: tokens[0].last!)
                insertions[pair] = [insert1, insert2]
            }
            return (template, insertions)
        }

        let puzzle = Puzzle14()

        print("Solution for part 1: \(puzzle.part1(template, insertions))")
        print("Solution for part 2: \(puzzle.part2(template, insertions))")
    }

    private func part1(_ template: String, _ insertions: [Pair: [Pair]]) -> Int {
        let timer = Timer(day: 14); defer { timer.show() }
        return growPolymer(from: template, with: insertions, generations: 10)
    }

    private func part2(_ template: String, _ insertions: [Pair: [Pair]]) -> Int {
        let timer = Timer(day: 14); defer { timer.show() }
        return growPolymer(from: template, with: insertions, generations: 40)
    }

    private func growPolymer(from template: String, with insertionRules: [Pair: [Pair]], generations: Int) -> Int {
        // get initial pairs from template
        var prev: Character?
        var pairs = [Pair: Int]()
        for ch in template {
            if let prev = prev {
                let p = Pair(a: prev, b: ch)
                pairs[p, default: 0] += 1
            }
            prev = ch
        }

        // grow for n generations
        for _ in 0..<generations {
            pairs = grow(pairs, with: insertionRules)
        }

        // add pair counts per element
        var counts = [Character: Int]()
        for (pair, count) in pairs {
            counts[pair.a, default: 0] += count
            counts[pair.b, default: 0] += count
        }

        let min = counts.map { $1 }.min()!
        let max = counts.map { $1 }.max()!

        return (max+1)/2 - (min+1)/2
    }

    private func grow(_ pairs: [Pair: Int], with insertionRules: [Pair: [Pair]]) -> [Pair: Int] {
        var nextPairs = [Pair: Int]()

        for (pair, count) in pairs {
            let insertions = insertionRules[pair]!
            nextPairs[insertions[0], default: 0] += count
            nextPairs[insertions[1], default: 0] += count
        }

        return nextPairs
    }
}
