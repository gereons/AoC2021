//
// Advent of Code 2021 Day 2 Tests
//

import Testing
@testable import AdventOfCode

fileprivate let testInput = """
forward 5
down 5
forward 8
up 3
down 8
forward 2
"""

@Suite("Day 2 Tests") 
struct Day02Tests {
    @Test("Day 2 Part 1", .tags(.testInput))
    func testDay02_part1() async {
        let day = Day02(input: testInput)
        #expect(day.part1() == 150)
    }

    @Test("Day 2 Part 1 Solution")
    func testDay02_part1_solution() async {
        let day = Day02(input: Day02.input)
        #expect(day.part1() == 1893605)
    }

    @Test("Day 2 Part 2", .tags(.testInput))
    func testDay02_part2() async {
        let day = Day02(input: testInput)
        #expect(day.part2() == 900)
    }

    @Test("Day 2 Part 2 Solution")
    func testDay02_part2_solution() async {
        let day = Day02(input: Day02.input)
        #expect(day.part2() == 2120734350)
    }
}
