//
// Advent of Code 2021 Day 12 Tests
//

import Testing
@testable import AdventOfCode

fileprivate let testInput1 = """
start-A
start-b
A-c
A-b
b-d
A-end
b-end
"""

fileprivate let testInput2 = """
dc-end
HN-start
start-kj
dc-start
dc-HN
LN-dc
HN-end
kj-sa
kj-HN
kj-dc
"""

fileprivate let testInput3 = """
fs-end
he-DX
fs-he
start-DX
pj-DX
end-zg
zg-sl
zg-pj
pj-he
RW-he
fs-DX
pj-RW
zg-RW
start-pj
he-WI
zg-he
pj-fs
start-RW
"""

@Suite("Day 12 Tests")
struct Day12Tests {
    @Test("Day 12 Part 1", .tags(.testInput))
    func testDay12_part1() async {
        var day = Day12(input: testInput1)
        #expect(day.part1() == 10)

        day = Day12(input: testInput2)
        #expect(day.part1() == 19)

        day = Day12(input: testInput3)
        #expect(day.part1() == 226)
    }

    @Test("Day 12 Part 1 Solution")
    func testDay12_part1_solution() async {
        let day = Day12(input: Day12.input)
        #expect(day.part1() == 4104)
    }

    @Test("Day 12 Part 2", .tags(.testInput))
    func testDay12_part2() async {
        var day = Day12(input: testInput1)
        #expect(day.part2() == 36)

        day = Day12(input: testInput2)
        #expect(day.part2() == 103)

        day = Day12(input: testInput3)
        #expect(day.part2() == 3509)
    }

    @Test("Day 12 Part 2 Solution")
    func testDay12_part2_solution() async {
        let day = Day12(input: Day12.input)
        #expect(day.part2() == 119760)
    }
}
