//
// Advent of Code 2021 Day 14
//

import AoCTools

final class Day14: AdventOfCodeDay {
    let title = "Extended Polymerization"

    struct Pair: Hashable {
        let a: Character
        let b: Character
    }

    let template: String
    let insertions: [Pair: [Pair]]

    init(input: String) {
        let lines = input.lines
        self.template = lines[0]

        var insertions = [Pair: [Pair]]()
        for line in lines.dropFirst(2) {
            let tokens = line.split(separator: " ")
            let pair = Pair(a: tokens[0].first!, b: tokens[0].last!)
            let insert1 = Pair(a: tokens[0].first!, b: tokens[2].first!)
            let insert2 = Pair(a: tokens[2].first!, b: tokens[0].last!)
            insertions[pair] = [insert1, insert2]
        }
        self.insertions = insertions
    }

    func part1() -> Int {
        return growPolymer(from: template, with: insertions, generations: 10)
    }

    func part2() -> Int {
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
