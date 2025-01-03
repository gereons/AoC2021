//
// Advent of Code 2021 Day 23 Tests
//

import Testing
@testable import AdventOfCode

fileprivate let testInput = """
#############
#...........#
###B#C#B#D###
  #A#D#C#A#
  #########
"""

@Suite("Day 23 Tests") 
struct Day23Tests {
    @Test("Day 23 Part 1", .tags(.testInput))
    func testDay23_part1() async {
        let day = Day23(input: testInput)
        #expect(day.part1() == 12521)
    }

    @Test("Day 23 Part 1 Solution")
    func testDay23_part1_solution() async {
        let day = Day23(input: Day23.input)
        #expect(day.part1() == 18170)
    }

    @Test("Day 23 Part 2", .tags(.testInput))
    func testDay23_part2() async {
        let day = Day23(input: testInput)
        #expect(day.part2() == 44169)
    }

    @Test("Day 23 Part 2 Solution")
    func testDay23_part2_solution() async {
        let day = Day23(input: Day23.input)
        #expect(day.part2() == 50208)
    }
}
