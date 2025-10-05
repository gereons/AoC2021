//
// Advent of Code 2021 Day 11
//

import AoCTools

final class Day11: AdventOfCodeDay {
    let title = "Dumbo Octopus"

    final class Grid: @unchecked Sendable {
        private(set) var data: [[Int]]

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
                    let point = Point(x, y)
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

            for dir in Direction.allCases {
                let np = point + dir
                if np.x >= 0 && np.x < size && np.y >= 0 && np.y < size {
                    result.append(np)
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

    let grid: Grid
    let initialData: [[Int]]

    init(input: String) {
        grid = Grid(data: input.lines.map { line in
            line.compactMap { Int(String($0)) }
        })
        initialData = grid.data
    }

    func part1() -> Int {
        for _ in 0 ..< 100 {
            let flashes = grid.increaseBrightness()
            grid.propagateFlashes(flashes)
        }

        return grid.flashCount
    }

    func part2() -> Int {
        let grid = Grid(data: initialData)
        for step in 0..<Int.max {
            let flashes = grid.increaseBrightness()
            grid.propagateFlashes(flashes)
            if grid.totalBrightness == 100 {
                return step
            }
        }
        fatalError()
    }
}
