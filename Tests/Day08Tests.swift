//
// Advent of Code 2021 Day 8 Tests
//

import Testing
@testable import AdventOfCode

fileprivate let testInput = """
be cfbegad cbdgef fgaecd cgeb fdcge agebfd fecdb fabcd edb | fdgacbe cefdb cefbgd gcbe
edbfga begcd cbg gc gcadebf fbgde acbgfd abcde gfcbed gfec | fcgedb cgb dgebacf gc
fgaebd cg bdaec gdafb agbcfd gdcbef bgcad gfac gcb cdgabef | cg cg fdcagb cbg
fbegcd cbd adcefb dageb afcb bc aefdc ecdab fgdeca fcdbega | efabcd cedba gadfec cb
aecbfdg fbg gf bafeg dbefa fcge gcbea fcaegb dgceab fcbdga | gecf egdcabf bgf bfgea
fgeab ca afcebg bdacfeg cfaedg gcfdb baec bfadeg bafgc acf | gebdcfa ecba ca fadegcb
dbcfg fgd bdegcaf fgec aegbdf ecdfab fbedc dacgb gdcebf gf | cefg dcbef fcge gbcadfe
bdfegc cbegaf gecbf dfcage bdacg ed bedf ced adcbefg gebcd | ed bcgafe cdgba cbgef
egadfb cdbfeg cegd fecab cgb gbdefca cg fgcdab egfdb bfceg | gbdfcae bgc cg cgb
gcafb gcf dcaebfg ecagb gf abcdeg gaef cafbge fdbac fegbdc | fgae cfgab fg bagce
"""

@Suite("Day 8 Tests")
struct Day08Tests {
    @Test("Day 8 Part 1", .tags(.testInput))
    func testDay08_part1() async {
        let day = Day08(input: testInput)
        #expect(day.part1() == 26)
    }

    @Test("Day 8 Part 1 Solution")
    func testDay08_part1_solution() async {
        let day = Day08(input: Day08.input)
        #expect(day.part1() == 548)
    }

    @Test("Day 8 Part 2", .tags(.testInput))
    func testDay08_part2() async {
        let day = Day08(input: testInput)
        #expect(day.part2() == 61229)
    }

    @Test("Day 8 Part 2 Solution")
    func testDay08_part2_solution() async {
        let day = Day08(input: Day08.input)
        #expect(day.part2() == 1074888)
    }
}
