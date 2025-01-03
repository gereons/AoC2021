//
// Advent of Code 2021 Day 17 Tests
//

import Testing
@testable import AdventOfCode

fileprivate let testInput = """
target area: x=20..30, y=-10..-5
"""

@Suite("Day 17 Tests") 
struct Day17Tests {
    @Test("Day 17 Part 1", .tags(.testInput))
    func testDay17_part1() async {
        let day = Day17(input: testInput)
        #expect(day.part1() == 45)
    }

    @Test("Day 17 Part 1 Solution")
    func testDay17_part1_solution() async {
        let day = Day17(input: Day17.input)
        #expect(day.part1() == 4560)
    }

    @Test("Day 17 Part 2", .tags(.testInput))
    func testDay17_part2() async {
        let day = Day17(input: testInput)
        #expect(day.part2() == 112)
    }

    @Test("Day 17 Part 2 Solution")
    func testDay17_part2_solution() async {
        let day = Day17(input: Day17.input)
        #expect(day.part2() == 3344)
    }
}
