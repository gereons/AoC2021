import Foundation

struct Puzzle11 {
    struct Point: Hashable {
        let x, y: Int
    }

    class Grid {
        private var data: [[Int]]

        var size: Int { data.count }

        private(set) var flashCount = 0

        init(data: [[Int]]) {
            self.data = data
        }

        // increase brightness in the whole grid, return coordinates of flashes
        func increaseBrightness() -> [Point] {
            var flashes = [Point]()
            for y in 0..<size {
                for x in 0..<size {
                    let point = Point(x: x, y: y)
                    let b = increaseBrightness(at: point)
                    if b == 10 {
                        flashes.append(point)
                    }
                }
            }
            return flashes
        }

        // increase brightess at point, return new brightness
        func increaseBrightness(at point: Point, dueToFlash: Bool = false) -> Int {
            var brightness = data[point.y][point.x]
            if brightness == 0 && dueToFlash {
                return 0
            }
            brightness += 1
            assert(brightness <= 10)
            data[point.y][point.x] = brightness == 10 ? 0 : brightness
            flashCount += brightness == 10 ? 1 : 0
            return brightness
        }

        // propagate flashes to neighbors
        func propagateFlashes(_ startFlashes: [Point]) {
            var flashesSoFar = Set(startFlashes)
            var flashes = startFlashes
            var nextFlashes = [Point]()

            repeat {
                nextFlashes = []
                for flashPoint in flashes {
                    for neighbor in neighbors(for: flashPoint) {
                        if flashesSoFar.contains(neighbor) {
                            continue
                        }
                        let b = increaseBrightness(at: neighbor, dueToFlash: true)
                        if b == 10 {
                            nextFlashes.append(neighbor)
                        }
                    }
                }
                flashes = nextFlashes
                flashesSoFar.formUnion(nextFlashes)
            } while !nextFlashes.isEmpty
        }

        func neighbors(for point: Point) -> [Point] {
            var result = [Point]()
            let offsets = [
                (-1, -1), (0, -1), (1, -1),
                (-1,  0),           (1, 0),
                (-1,  1),  (0, 1),  (1, 1)
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

        // total brightness of all octopuses
        var totalBrightness: Int {
            return data.reduce(0) { sum, line in
                sum + line.reduce(0, +)
            }
        }

        func show() {
            for y in 0..<size {
                for x in 0..<size {
                    print(data[y][x], terminator: "")
                }
                print()
            }
        }
    }

    static let testData = [
        "5483143223",
        "2745854711",
        "5264556173",
        "6141336146",
        "6357385478",
        "4167524645",
        "2176841721",
        "6882881134",
        "4846848554",
        "5283751526"
    ]

    static func run() {
        // let data = testData
        let data = readFile(named: "puzzle11.txt")

        let puzzle = Puzzle11()
        let grid = Timer.time(day: 10) {
            Grid(data: data.map { line in
                line.compactMap { Int(String($0)) }
            })
        }

        print("Solution for part 1: \(puzzle.part1(grid))")
        print("Solution for part 2: \(puzzle.part2(grid))")
    }

    private func part1(_ grid: Grid) -> Int {
        let timer = Timer(day: 10); defer { timer.show() }
        for _ in 0 ..< 100 {
            let flashes = grid.increaseBrightness()
            grid.propagateFlashes(flashes)
        }

        return grid.flashCount
    }

    private func part2(_ grid: Grid) -> Int {
        let timer = Timer(day: 10); defer { timer.show() }
        for step in 0..<Int.max {
            let flashes = grid.increaseBrightness()
            grid.propagateFlashes(flashes)
            if grid.totalBrightness == 100 {
                return step + 100
            }
        }
        fatalError()
    }
}
