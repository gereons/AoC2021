//
// Advent of Code 2021 Day 13 Tests
//

import Testing
@testable import AdventOfCode

fileprivate let testInput = """
6,10
0,14
9,10
0,3
10,4
4,11
6,0
6,12
4,1
0,13
10,12
3,4
3,0
8,4
1,10
2,14
8,10
9,0

fold along y=7
fold along x=5
"""

@Suite("Day 13 Tests")
struct Day13Tests {
    @Test("Day 13 Part 1", .tags(.testInput))
    func testDay13_part1() async {
        let day = Day13(input: testInput)
        #expect(day.part1() == 17)
    }

    @Test("Day 13 Part 1 Solution")
    func testDay13_part1_solution() async {
        let day = Day13(input: Day13.input)
        #expect(day.part1() == 818)
    }

    @Test("Day 13 Part 2 Solution")
    func testDay13_part2_solution() async {
        let day = Day13(input: Day13.input)
        #expect(day.part2() == "LRGPRECB")
    }
}
