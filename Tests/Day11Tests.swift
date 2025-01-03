//
// Advent of Code 2021 Day 11 Tests
//

import Testing
@testable import AdventOfCode

fileprivate let testInput = """
5483143223
2745854711
5264556173
6141336146
6357385478
4167524645
2176841721
6882881134
4846848554
5283751526
"""

@Suite("Day 11 Tests") 
struct Day11Tests {
    @Test("Day 11 Part 1", .tags(.testInput))
    func testDay11_part1() async {
        let day = Day11(input: testInput)
        #expect(day.part1() == 1656)
    }

    @Test("Day 11 Part 1 Solution")
    func testDay11_part1_solution() async {
        let day = Day11(input: Day11.input)
        #expect(day.part1() == 1665)
    }

    @Test("Day 11 Part 2", .tags(.testInput))
    func testDay11_part2() async {
        let day = Day11(input: testInput)
        #expect(day.part2() == 195)
    }

    @Test("Day 11 Part 2 Solution")
    func testDay11_part2_solution() async {
        let day = Day11(input: Day11.input)
        #expect(day.part2() == 235)
    }
}
