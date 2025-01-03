//
// Advent of Code 2021 Day 25 Tests
//

import Testing
@testable import AdventOfCode

fileprivate let testInput = """
v...>>.vv>
.vv>>.vv..
>>.>v>...v
>>v>>.>.v.
v>v.vv.v..
>.>>..v...
.vv..>.>v.
v.v..>>v.v
....v..v.>
"""

@Suite("Day 25 Tests") 
struct Day25Tests {
    @Test("Day 25 Part 1", .tags(.testInput))
    func testDay25_part1() async {
        let day = Day25(input: testInput)
        #expect(day.part1() == 58)
    }

    @Test("Day 25 Part 1 Solution")
    func testDay25_part1_solution() async {
        let day = Day25(input: Day25.input)
        #expect(day.part1() == 549)
    }
}
