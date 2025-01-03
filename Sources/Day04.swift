//
// Advent of Code 2021 Day 4
//

import AoCTools

final class Day04: AdventOfCodeDay {
    let title: String = "Giant Squid"

    struct Entry {
        let number: Int
        var called: Bool = false
    }

    struct Board {
        var entries = [[Entry]]()

        init(from lines: [String]) {
            for line in lines {
                let digits = line.split(separator: " ")
                    .compactMap { Int($0) }
                    .map { Entry(number: $0) }
                entries.append(digits)
            }
        }

        mutating func mark(_ number: Int) {
            for i in 0..<entries.count {
                for j in 0..<entries[i].count {
                    if entries[i][j].number == number {
                        entries[i][j].called = true
                    }
                }
            }
        }

        // row or column completely called
        var bingo: Bool {
            // check rows
            for row in entries {
                if row.allSatisfy({ $0.called }) {
                    return true
                }
            }

            // check columns
            for index in 0..<entries[0].count {
                var called = 0
                for row in entries {
                    if row[index].called {
                        called += 1
                    }
                }
                if called == entries.count {
                    return true
                }
            }
            return false
        }

        var score: Int {
            var sum = 0
            for row in entries {
                for entry in row {
                    if !entry.called {
                        sum += entry.number
                    }
                }
            }
            return sum
        }
    }

    let numbers: [Int]
    let boards: [Board]

    init(input: String) {
        let data = input.lines

        numbers = data[0].split(separator: ",").map { Int($0)! }
        boards = stride(from: 1, through: data.count-1, by: 6).map { index in
            Board(from: Array(data[index+1..<index+6]))
        }
    }

    // find first winner
    func part1() -> Int {
        var boards = boards
        for number in numbers {
            for index in 0..<boards.count {
                boards[index].mark(number)
                if boards[index].bingo {
                    return boards[index].score * number
                }
            }
        }

        fatalError("no winner")
    }

    // find last winner
    func part2() -> Int {
        var boards = boards
        var winners = Set<Int>()
        for number in numbers {
            for index in 0..<boards.count {
                boards[index].mark(number)
                if !winners.contains(index) && boards[index].bingo {
                    winners.insert(index)
                    if winners.count == boards.count {
                        return boards[index].score * number
                    }
                }
            }
        }

        fatalError("no winner")
    }
}
