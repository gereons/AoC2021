//
// Advent of Code 2021 Day 21 Tests
//

import Testing
@testable import AdventOfCode

fileprivate let testInput = """
Player 1 starting position: 4
Player 2 starting position: 8
"""

@Suite("Day 21 Tests") 
struct Day21Tests {
    @Test("Day 21 Part 1", .tags(.testInput))
    func testDay21_part1() async {
        let day = Day21(input: testInput)
        #expect(day.part1() == 739785)
    }

    @Test("Day 21 Part 1 Solution")
    func testDay21_part1_solution() async {
        let day = Day21(input: Day21.input)
        #expect(day.part1() == 908595)
    }

    @Test("Day 21 Part 2", .tags(.testInput))
    func testDay21_part2() async {
        let day = Day21(input: testInput)
        #expect(day.part2() == 444356092776315)
    }

    @Test("Day 21 Part 2 Solution")
    func testDay21_part2_solution() async {
        let day = Day21(input: Day21.input)
        #expect(day.part2() == 91559198282731)
    }
}
