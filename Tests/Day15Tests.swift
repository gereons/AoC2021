//
// Advent of Code 2021 Day 15 Tests
//

import Testing
@testable import AdventOfCode

fileprivate let testInput = """
1163751742
1381373672
2136511328
3694931569
7463417111
1319128137
1359912421
3125421639
1293138521
2311944581
"""

@Suite("Day 15 Tests") 
struct Day15Tests {
    @Test("Day 15 Part 1", .tags(.testInput))
    func testDay15_part1() async {
        let day = Day15(input: testInput)
        #expect(day.part1() == 40)
    }

    @Test("Day 15 Part 1 Solution")
    func testDay15_part1_solution() async {
        let day = Day15(input: Day15.input)
        #expect(day.part1() == 386)
    }

    @Test("Day 15 Part 2", .tags(.testInput))
    func testDay15_part2() async {
        let day = Day15(input: testInput)
        #expect(day.part2() == 315)
    }

    @Test("Day 15 Part 2 Solution")
    func testDay15_part2_solution() async {
        let day = Day15(input: Day15.input)
        #expect(day.part2() == 2806)
    }
}
