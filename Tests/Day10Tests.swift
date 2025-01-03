//
// Advent of Code 2021 Day 10 Tests
//

import Testing
@testable import AdventOfCode

fileprivate let testInput = """
[({(<(())[]>[[{[]{<()<>>
[(()[<>])]({[<{<<[]>>(
{([(<{}[<>[]}>{[]{[(<()>
(((({<>}<{<{<>}{[]{[]{}
[[<[([]))<([[{}[[()]]]
[{[{({}]{}}([{[{{{}}([]
{<[[]]>}<{[{[{[]{()[[[]
[<(<(<(<{}))><([]([]()
<{([([[(<>()){}]>(<<{{
<{([{{}}[<[[[<>{}]]]>[]]
"""

@Suite("Day 10 Tests") 
struct Day10Tests {
    @Test("Day 10 Part 1", .tags(.testInput))
    func testDay10_part1() async {
        let day = Day10(input: testInput)
        #expect(day.part1() == 26397)
    }

    @Test("Day 10 Part 1 Solution")
    func testDay10_part1_solution() async {
        let day = Day10(input: Day10.input)
        #expect(day.part1() == 315693)
    }

    @Test("Day 10 Part 2", .tags(.testInput))
    func testDay10_part2() async {
        let day = Day10(input: testInput)
        #expect(day.part2() == 288957)
    }

    @Test("Day 10 Part 2 Solution")
    func testDay10_part2_solution() async {
        let day = Day10(input: Day10.input)
        #expect(day.part2() == 1870887234)
    }
}
