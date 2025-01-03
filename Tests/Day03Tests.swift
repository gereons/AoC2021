//
// Advent of Code 2021 Day 3 Tests
//

import Testing
@testable import AdventOfCode

fileprivate let testInput = """
00100
11110
10110
10111
10101
01111
00111
11100
10000
11001
00010
01010
"""

@Suite("Day 3 Tests")
struct Day03Tests {
    @Test("Day 3 Part 1", .tags(.testInput))
    func testDay03_part1() async {
        let day = Day03(input: testInput)
        #expect(day.part1() == 198)
    }

    @Test("Day 3 Part 1 Solution")
    func testDay03_part1_solution() async {
        let day = Day03(input: Day03.input)
        #expect(day.part1() == 2583164)
    }

    @Test("Day 3 Part 2", .tags(.testInput))
    func testDay03_part2() async {
        let day = Day03(input: testInput)
        #expect(day.part2() == 230)
    }

    @Test("Day 3 Part 2 Solution")
    func testDay03_part2_solution() async {
        let day = Day03(input: Day03.input)
        #expect(day.part2() == 2784375)
    }
}
