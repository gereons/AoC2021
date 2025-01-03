//
// Advent of Code 2021 Day 20 Tests
//

import Testing
@testable import AdventOfCode

fileprivate let testInput = """
..#.#..#####.#.#.#.###.##.....###.##.#..###.####..#####..#....#..#..##..###..######.###...####..#..#####..##..#.#####...##.#.#..#.##..#.#......#.###.######.###.####...#.##.##..#..#..#####.....#.#....###..#.##......#.....#..#..#..##..#...##.######.####.####.#.#...#.......#..#.#.#...####.##.#......#..#...##.#.##..#...##.#.##..###.#......#.#.......#.#.#.####.###.##...#.....####.#..#..#.##.#....##..#.####....##...##..#...#......#.#.......#.......##..####..#...#.#.#...##..#.#..###..#####........#..####......#..#

#..#.
#....
##..#
..#..
..###
"""

@Suite("Day 20 Tests") 
struct Day20Tests {
    @Test("Day 20 Part 1", .tags(.testInput))
    func testDay20_part1() async {
        let day = Day20(input: testInput)
        #expect(day.part1() == 35)
    }

    @Test("Day 20 Part 1 Solution")
    func testDay20_part1_solution() async {
        let day = Day20(input: Day20.input)
        #expect(day.part1() == 5259)
    }

    @Test("Day 20 Part 2", .tags(.testInput))
    func testDay20_part2() async {
        let day = Day20(input: testInput)
        #expect(day.part2() == 3351)
    }

    @Test("Day 20 Part 2 Solution")
    func testDay20_part2_solution() async {
        let day = Day20(input: Day20.input)
        #expect(day.part2() == 15287)
    }
}
