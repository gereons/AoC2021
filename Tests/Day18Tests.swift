//
// Advent of Code 2021 Day 18 Tests
//

import Testing
@testable import AdventOfCode

fileprivate let testInput = """
[[[0,[5,8]],[[1,7],[9,6]]],[[4,[1,2]],[[1,4],2]]]
[[[5,[2,8]],4],[5,[[9,9],0]]]
[6,[[[6,2],[5,6]],[[7,6],[4,7]]]]
[[[6,[0,7]],[0,9]],[4,[9,[9,0]]]]
[[[7,[6,4]],[3,[1,3]]],[[[5,5],1],9]]
[[6,[[7,3],[3,2]]],[[[3,8],[5,7]],4]]
[[[[5,4],[7,7]],8],[[8,3],8]]
[[9,3],[[9,9],[6,[4,9]]]]
[[2,[[7,7],7]],[[5,8],[[9,3],[0,2]]]]
[[[[5,2],5],[8,[3,7]]],[[5,[7,5]],[4,4]]]
"""

@Suite("Day 18 Tests") 
struct Day18Tests {
    @Test("Day 18 Part 1", .tags(.testInput))
    func testDay18_part1() async {
        let day = Day18(input: testInput)
        #expect(day.part1() == 4140)
    }

    @Test("Day 18 Part 1 Solution")
    func testDay18_part1_solution() async {
        let day = Day18(input: Day18.input)
        #expect(day.part1() == 3524)
    }

    @Test("Day 18 Part 2", .tags(.testInput))
    func testDay18_part2() async {
        let day = Day18(input: testInput)
        #expect(day.part2() == 3993)
    }

    @Test("Day 18 Part 2 Solution")
    func testDay18_part2_solution() async {
        let day = Day18(input: Day18.input)
        #expect(day.part2() == 4656)
    }
}
