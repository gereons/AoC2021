import Foundation

struct Puzzle25 {
    static let testData = [
        "v...>>.vv>",
        ".vv>>.vv..",
        ">>.>v>...v",
        ">>v>>.>.v.",
        "v>v.vv.v..",
        ">.>>..v...",
        ".vv..>.>v.",
        "v.v..>>v.v",
        "....v..v.>"
    ]

    enum Cucumber {
        case east, south
    }

    struct Point: Hashable {
        let x,y: Int
    }

    class Grid {
        var points = [Point: Cucumber]()
        let maxX: Int
        let maxY: Int

        init(_ data: [String]) {
            maxY = data.count
            maxX = data[0].count
            for (y, line) in data.enumerated() {
                for (x, ch) in line.enumerated() {
                    if ch == "." { continue }
                    let point = Point(x: x, y: y)
                    points[point] = ch == ">" ? .east : .south
                }
            }
        }

        func show() {
            for y in 0..<maxY {
                for x in 0..<maxX {
                    let point = Point(x: x, y: y)
                    switch points[point] {
                    case .east: print(">", terminator: "")
                    case .south: print("v", terminator: "")
                    case .none: print(".", terminator: "")
                    }
                }
                print()
            }
            print("\n")
        }

        func move() -> Int {
            let e = move(.east)
            let s = move(.south)
            return e + s
        }

        private func move(_ type: Cucumber) -> Int {
            let herd = points.filter { $1 == type }

            var next = [Point: Cucumber]()
            var movers = [Point]()
            for (point, type) in herd {
                let n = neighbor(for: point)
                if points[n] == nil {
                    movers.append(point)
                    next[n] = type
                }
            }

            movers.forEach {
                points[$0] = nil
            }
            next.forEach { k, v in
                points[k] = v
            }
            return movers.count
        }

        private func neighbor(for point: Point) -> Point {
            switch points[point] {
            case .east:
                var x = point.x + 1
                if x > maxX - 1 { x = 0 }
                return Point(x: x, y: point.y)
            case .south:
                var y = point.y + 1
                if y > maxY - 1 { y = 0 }
                return Point(x: point.x, y: y)
            case .none:
                fatalError()
            }
        }
    }

    static func run() {
        let data = readFile(named: "puzzle25.txt")

        let grid = Timer.time(day: 25) {
            Grid(data)
        }
        let puzzle = Puzzle25()

        print("Solution for part 1: \(puzzle.part1(grid))")
        print("Solution for part 2: \(puzzle.part2(data))")
    }

    private func part1(_ grid: Grid) -> Int {
        let timer = Timer(day: 25); defer { timer.show() }

        for i in 1..<Int.max {
            let m = grid.move()
            if m == 0 {
                return i
            }
        }

        fatalError()
    }

    private func part2(_ data: [String]) -> Int {
        let timer = Timer(day: 25); defer { timer.show() }
        return 42
    }
}
