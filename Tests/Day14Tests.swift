//
// Advent of Code 2021 Day 14 Tests
//

import Testing
@testable import AdventOfCode

fileprivate let testInput = """
NNCB

CH -> B
HH -> N
CB -> H
NH -> C
HB -> C
HC -> B
HN -> C
NN -> C
BH -> H
NC -> B
NB -> B
BN -> B
BB -> N
BC -> B
CC -> N
CN -> C
"""

@Suite("Day 14 Tests") 
struct Day14Tests {
    @Test("Day 14 Part 1", .tags(.testInput))
    func testDay14_part1() async {
        let day = Day14(input: testInput)
        #expect(day.part1() == 1588)
    }

    @Test("Day 14 Part 1 Solution")
    func testDay14_part1_solution() async {
        let day = Day14(input: Day14.input)
        #expect(day.part1() == 2712)
    }

    @Test("Day 14 Part 2", .tags(.testInput))
    func testDay14_part2() async {
        let day = Day14(input: testInput)
        #expect(day.part2() == 2188189693529)
    }

    @Test("Day 14 Part 2 Solution")
    func testDay14_part2_solution() async {
        let day = Day14(input: Day14.input)
        #expect(day.part2() == 8336623059567)
    }
}
