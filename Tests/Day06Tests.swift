//
// Advent of Code 2021 Day 6 Tests
//

import Testing
@testable import AdventOfCode

fileprivate let testInput = """
3,4,3,1,2
"""

@Suite("Day 6 Tests") 
struct Day06Tests {
    @Test("Day 6 Part 1", .tags(.testInput))
    func testDay06_part1() async {
        let day = Day06(input: testInput)
        #expect(day.part1() == 5934)
    }

    @Test("Day 6 Part 1 Solution")
    func testDay06_part1_solution() async {
        let day = Day06(input: Day06.input)
        #expect(day.part1() == 358214)
    }

    @Test("Day 6 Part 2", .tags(.testInput))
    func testDay06_part2() async {
        let day = Day06(input: testInput)
        #expect(day.part2() == 26984457539)
    }

    @Test("Day 6 Part 2 Solution")
    func testDay06_part2_solution() async {
        let day = Day06(input: Day06.input)
        #expect(day.part2() == 1622533344325)
    }
}
