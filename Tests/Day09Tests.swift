//
// Advent of Code 2021 Day 9 Tests
//

import Testing
@testable import AdventOfCode

fileprivate let testInput = """
2199943210
3987894921
9856789892
8767896789
9899965678
"""

@Suite("Day 9 Tests")
struct Day09Tests {
    @Test("Day 9 Part 1", .tags(.testInput))
    func testDay09_part1() async {
        let day = Day09(input: testInput)
        #expect(day.part1() == 15)
    }

    @Test("Day 9 Part 1 Solution")
    func testDay09_part1_solution() async {
        let day = Day09(input: Day09.input)
        #expect(day.part1() == 537)
    }

    @Test("Day 9 Part 2", .tags(.testInput))
    func testDay09_part2() async {
        let day = Day09(input: testInput)
        #expect(day.part2() == 1134)
    }

    @Test("Day 9 Part 2 Solution")
    func testDay09_part2_solution() async {
        let day = Day09(input: Day09.input)
        #expect(day.part2() == 1142757)
    }
}
