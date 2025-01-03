//
// Advent of Code 2021 Day 1 Tests
//

import Testing
@testable import AdventOfCode

fileprivate let testInput = """
199
200
208
210
200
207
240
269
260
263
"""

@Suite("Day 1 Tests") 
struct Day01Tests {
    @Test("Day 1 Part 1", .tags(.testInput))
    func testDay01_part1() async {
        let day = Day01(input: testInput)
        #expect(day.part1() == 7)
    }

    @Test("Day 1 Part 1 Solution")
    func testDay01_part1_solution() async {
        let day = Day01(input: Day01.input)
        #expect(day.part1() == 1532)
    }

    @Test("Day 1 Part 2", .tags(.testInput))
    func testDay01_part2() async {
        let day = Day01(input: testInput)
        #expect(day.part2() == 5)
    }

    @Test("Day 1 Part 2 Solution")
    func testDay01_part2_solution() async {
        let day = Day01(input: Day01.input)
        #expect(day.part2() == 1571)
    }
}
