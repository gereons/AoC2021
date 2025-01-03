//
// Advent of Code 2021 Day 4 Tests
//

import Testing
@testable import AdventOfCode

fileprivate let testInput = """
7,4,9,5,11,17,23,2,0,14,21,24,10,16,13,6,15,25,12,22,18,20,8,19,3,26,1

22 13 17 11  0
 8  2 23  4 24
21  9 14 16  7
 6 10  3 18  5
 1 12 20 15 19

 3 15  0  2 22
 9 18 13 17  5
19  8  7 25 23
20 11 10 24  4
14 21 16 12  6

14 21 17 24  4
10 16 15  9 19
18  8 23 26 20
22 11 13  6  5
 2  0 12  3  7
"""

@Suite("Day 4 Tests")
struct Day04Tests {
    @Test("Day 4 Part 1", .tags(.testInput))
    func testDay04_part1() async {
        let day = Day04(input: testInput)
        #expect(day.part1() == 4512)
    }

    @Test("Day 4 Part 1 Solution")
    func testDay04_part1_solution() async {
        let day = Day04(input: Day04.input)
        #expect(day.part1() == 63424)
    }

    @Test("Day 4 Part 2", .tags(.testInput))
    func testDay04_part2() async {
        let day = Day04(input: testInput)
        #expect(day.part2() == 1924)
    }

    @Test("Day 4 Part 2 Solution")
    func testDay04_part2_solution() async {
        let day = Day04(input: Day04.input)
        #expect(day.part2() == 23541)
    }
}
