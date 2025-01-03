//
// Advent of Code 2021 Day 7 Tests
//

import Testing
@testable import AdventOfCode

fileprivate let testInput = """
16,1,2,0,4,2,7,1,2,14
"""

@Suite("Day 7 Tests")
struct Day07Tests {
    @Test("Day 7 Part 1", .tags(.testInput))
    func testDay07_part1() async {
        let day = Day07(input: testInput)
        #expect(day.part1() == 37)
    }

    @Test("Day 7 Part 1 Solution")
    func testDay07_part1_solution() async {
        let day = Day07(input: Day07.input)
        #expect(day.part1() == 356179)
    }

    @Test("Day 7 Part 2", .tags(.testInput))
    func testDay07_part2() async {
        let day = Day07(input: testInput)
        #expect(day.part2() == 168)
    }

    @Test("Day 7 Part 2 Solution")
    func testDay07_part2_solution() async {
        let day = Day07(input: Day07.input)
        #expect(day.part2() == 99788435)
    }
}
