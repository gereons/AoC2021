//
// Advent of Code 2021 Day 5 Tests
//

import Testing
@testable import AdventOfCode

fileprivate let testInput = """
0,9 -> 5,9
8,0 -> 0,8
9,4 -> 3,4
2,2 -> 2,1
7,0 -> 7,4
6,4 -> 2,0
0,9 -> 2,9
3,4 -> 1,4
0,0 -> 8,8
5,5 -> 8,2
"""

@Suite("Day 5 Tests")
struct Day05Tests {
    @Test("Day 5 Part 1", .tags(.testInput))
    func testDay05_part1() async {
        let day = Day05(input: testInput)
        #expect(day.part1() == 5)
    }

    @Test("Day 5 Part 1 Solution")
    func testDay05_part1_solution() async {
        let day = Day05(input: Day05.input)
        #expect(day.part1() == 7269)
    }

    @Test("Day 5 Part 2", .tags(.testInput))
    func testDay05_part2() async {
        let day = Day05(input: testInput)
        #expect(day.part2() == 12)
    }

    @Test("Day 5 Part 2 Solution")
    func testDay05_part2_solution() async {
        let day = Day05(input: Day05.input)
        #expect(day.part2() == 21140)
    }
}
