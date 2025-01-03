//
// Advent of Code 2021 Day 16 Tests
//

import Testing
@testable import AdventOfCode

@Suite("Day 16 Tests") 
struct Day16Tests {
    @Test("Day 16 Part 1", .tags(.testInput))
    func testDay16_part1() async {
        let data = [
            ("8A004A801A8002F478", 16),
            ("620080001611562C8802118E34", 12),
            ("C0015000016115A2E0802F182340", 23),
            ("A0016C880162017C3686B18A3D4780", 31)
        ]
        for d in data {
            let day = Day16(input: d.0)
            #expect(day.part1() == d.1)
        }
    }

    @Test("Day 16 Part 1 Solution")
    func testDay16_part1_solution() async {
        let day = Day16(input: Day16.input)
        #expect(day.part1() == 993)
    }

    @Test("Day 16 Part 2", .tags(.testInput))
    func testDay16_part2() async {
        let data = [
            ("C200B40A82", 3), // finds the sum of 1 and 2, resulting in the value 3.
            ("04005AC33890", 54), // finds the product of 6 and 9, resulting in the value 54.
            ("880086C3E88112", 7), // finds the minimum of 7, 8, and 9, resulting in the value 7.
            ("CE00C43D881120", 9), // finds the maximum of 7, 8, and 9, resulting in the value 9.
            ("D8005AC2A8F0", 1), // produces 1, because 5 is less than 15.
            ("F600BC2D8F", 0), // produces 0, because 5 is not greater than 15.
            ("9C005AC2F8F0", 0), // produces 0, because 5 is not equal to 15.
            ("9C0141080250320F1802104A08", 1) // produces 1, because 1 + 3 = 2 * 2.
        ]

        for d in data {
            let day = Day16(input: d.0)
            #expect(day.part2() == d.1)
        }
    }

    @Test("Day 16 Part 2 Solution")
    func testDay16_part2_solution() async {
        let day = Day16(input: Day16.input)
        #expect(day.part2() == 144595909277)
    }
}
