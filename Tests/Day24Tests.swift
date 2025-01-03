//
// Advent of Code 2021 Day 24 Tests
//

import Testing
@testable import AdventOfCode

@Suite("Day 24 Tests")
struct Day24Tests {
    @Test("Day 24 Part 1 Solution")
    func testDay24_part1_solution() async {
        let day = Day24(input: Day24.input)
        #expect(day.part1() == "96918996924991")
    }

    @Test("Day 24 Part 2 Solution")
    func testDay24_part2_solution() async {
        let day = Day24(input: Day24.input)
        #expect(day.part2() == "91811241911641")
    }
}
