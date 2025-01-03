//
// Advent of Code 2021 Day 25
//

import AoCTools

final class Day25: AdventOfCodeDay {
    let title = "Sea Cucumber"

    enum Cucumber {
        case east, south
    }

    final class Grid {
        var points = [Point: Cucumber]()
        let maxX: Int
        let maxY: Int

        init(_ data: [String]) {
            maxY = data.count
            maxX = data[0].count
            for (y, line) in data.enumerated() {
                for (x, ch) in line.enumerated() {
                    if ch == "." { continue }
                    let point = Point(x, y)
                    points[point] = ch == ">" ? .east : .south
                }
            }
        }

        func show() {
            for y in 0..<maxY {
                for x in 0..<maxX {
                    let point = Point(x, y)
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
                return Point(x, point.y)
            case .south:
                var y = point.y + 1
                if y > maxY - 1 { y = 0 }
                return Point(point.x, y)
            case .none:
                fatalError()
            }
        }
    }

    let grid: Grid

    init(input: String) {
        grid = Grid(input.lines)
    }

    func part1() -> Int {
        for i in 1..<Int.max {
            let m = grid.move()
            if m == 0 {
                return i
            }
        }

        fatalError()
    }

    func part2() { }
}
