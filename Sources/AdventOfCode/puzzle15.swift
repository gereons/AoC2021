import Foundation

private struct Point: Hashable {
    let x, y: Int
}

private class Grid {
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
    typealias Coordinate = Point

    func hScore(from: Point, to: Point) -> Int {
        return abs(from.x - to.x) + abs(from.y - to.y)
    }

    func costToMove(from: Point, to: Point) -> Int {
        data[to.y][to.x]
    }

    func neighbors(for point: Point) -> [Point] {
        var result = [Point]()
        let offsets = [
                      (0, -1),
            (-1,  0),           (1, 0),
                      (0,  1),
        ]

        for offset in offsets {
            let nx = point.x + offset.0
            let ny = point.y + offset.1
            if nx >= 0 && nx < size && ny >= 0 && ny < size {
                result.append(Point(x: nx, y: ny))
            }
        }

        return result
    }
}

struct Puzzle15 {

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

    static func run() {
        // let data = testData
        let data = readFile(named: "puzzle15.txt")

        let grid = Timer.time(day: 15) {
            Grid(data: data.map { line in
                line.compactMap { Int(String($0)) }
            })
        }

        let puzzle = Puzzle15()

        print("Solution for part 1: \(puzzle.part1(grid))")
        print("Solution for part 2: \(puzzle.part2(grid))")
    }

    private func part1(_ grid: Grid) -> Int {
        let timer = Timer(day: 15); defer { timer.show() }

        let aStar = AStarPathfinder(grid: grid)
        let path = aStar.shortestPathFrom(Point(x: 0, y: 0), to: Point(x: grid.size-1, y: grid.size-1))

        var risk = 0
        for point in path.dropFirst() {
            risk += grid.value(at: point)
        }

        return risk
    }

    private func part2(_ grid: Grid) -> Int {
        let timer = Timer(day: 15); defer { timer.show() }

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

        let aStar = AStarPathfinder(grid: largeGrid)
        let path = aStar.shortestPathFrom(Point(x: 0, y: 0), to: Point(x: largeGrid.size-1, y: largeGrid.size-1))

        var risk = 0
        for point in path.dropFirst() {
            risk += largeGrid.value(at: point)
        }

        return risk
    }
}
