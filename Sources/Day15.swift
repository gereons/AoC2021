//
// Advent of Code 2021 Day 15
//

import AoCTools

private final class Grid {
    private var data: [[Int]]

    var size: Int { data.count }

    init(data: [[Int]]) {
        self.data = data
    }

    static func stitch(_ grids: [[Grid]]) -> Grid {
        var data = [[Int]]()

        for outerY in 0 ..< grids.count {
            let size = grids[outerY][0].size
            for innerY in 0 ..< size {
                var line = [Int]()
                for outerX in 0 ..< grids.count {
                    let grid = grids[outerY][outerX]
                    line.append(contentsOf: grid.data[innerY])
                }
                data.append(line)
            }
        }

        return Grid(data: data)
    }

    func value(at point: Point) -> Int {
        data[point.y][point.x]
    }

    func show() {
        for y in 0..<size {
            for x in 0..<size {
                print(data[y][x], terminator: "")
            }
            print()
        }
    }

    func add(_ n: Int) -> Grid {
        var data = self.data
        for y in 0..<size {
            for x in 0..<size {
                var newValue = data[y][x] + n
                if newValue > 9 { newValue -= 9 }
                data[y][x] = newValue
            }
        }
        return Grid(data: data)
    }
}

// Pathfinding conformance
extension Grid: Pathfinding {
    func costToMove(from: Point, to: Point) -> Int {
        data[to.y][to.x]
    }

    func neighbors(of point: Point) -> [Point] {
        var result = [Point]()

        for dir in Direction.orthogonal {
            let np = point + dir
            if np.x >= 0 && np.x < size && np.y >= 0 && np.y < size {
                result.append(np)
            }
        }

        return result
    }
}

final class Day15: AdventOfCodeDay {
    let title = "Chiton"

    static let testData = [
        "1163751742",
        "1381373672",
        "2136511328",
        "3694931569",
        "7463417111",
        "1319128137",
        "1359912421",
        "3125421639",
        "1293138521",
        "2311944581"
    ]

    private let grid: Grid

    init(input: String) {
        grid = Grid(data: input.lines.map { line in
            line.compactMap { Int(String($0)) }
        })
    }

    func part1() -> Int {
        let aStar = AStarPathfinder(map: grid)
        let path = aStar.shortestPath(from: .zero, to: Point(grid.size-1, grid.size-1))

        var risk = 0
        for point in path {
            risk += grid.value(at: point)
        }

        return risk
    }

    func part2() -> Int {
        var grids = [grid]
        for n in 1...9 {
            grids.append(grid.add(n))
        }

        let largeGrid = Grid.stitch([
            [grids[0], grids[1], grids[2], grids[3], grids[4]],
            [grids[1], grids[2], grids[3], grids[4], grids[5]],
            [grids[2], grids[3], grids[4], grids[5], grids[6]],
            [grids[3], grids[4], grids[5], grids[6], grids[7]],
            [grids[4], grids[5], grids[6], grids[7], grids[8]],
        ])

        let aStar = AStarPathfinder(map: largeGrid)
        let path = aStar.shortestPath(from: .zero, to: Point(largeGrid.size-1, largeGrid.size-1))

        var risk = 0
        for point in path {
            risk += largeGrid.value(at: point)
        }

        return risk
    }
}
