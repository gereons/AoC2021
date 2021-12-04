import Foundation

// Solution for part 1: 63424
// Solution for part 2: 23541

struct Puzzle4 {
    static let testData = [
         "7,4,9,5,11,17,23,2,0,14,21,24,10,16,13,6,15,25,12,22,18,20,8,19,3,26,1",
         "",
         "22 13 17 11  0",
         " 8  2 23  4 24",
         "21  9 14 16  7",
         " 6 10  3 18  5",
         " 1 12 20 15 19",
         "",
         " 3 15  0  2 22",
         " 9 18 13 17  5",
         "19  8  7 25 23",
         "20 11 10 24  4",
         "14 21 16 12  6",
         "",
         "14 21 17 24  4",
         "10 16 15  9 19",
         "18  8 23 26 20",
         "22 11 13  6  5",
         " 2  0 12  3  7",
    ]

    struct Entry {
        let number: Int
        var called: Bool = false
    }

    struct Board {
        var entries = [[Entry]]()

        init(from lines: [String]) {
            for line in lines {
                let digits = line.components(separatedBy: " ")
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
                if row.filter({ $0.called }).count == row.count {
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

    static func run() {
        // let data = Self.testData
        let data = readFile(named: "puzzle4.txt")

        let numbers = data[0].components(separatedBy: ",").compactMap { Int($0) }

        var boards = [Board]()
        for index in stride(from: 1, through: data.count-1, by: 6) {
            let range = data[index+1..<index+6]
            let board = Board(from: Array(range))
            boards.append(board)
        }

        let puzzle = Puzzle4()

        print("Solution for part 1: \(puzzle.part1(numbers, boards))")
        print("Solution for part 2: \(puzzle.part2(numbers, boards))")
    }

    // find first winner
    private func part1(_ numbers: [Int], _ initialBoards: [Board]) -> Int {
        let timer = Timer(day: 4); defer { timer.show() }
        var boards = initialBoards
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
    private func part2(_ numbers: [Int], _ initialBoards: [Board]) -> Int {
        let timer = Timer(day: 4); defer { timer.show() }
        var boards = initialBoards
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
