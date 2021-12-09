// Solution for part 1: 537
// Solution for part 2: 1142757

struct Puzzle9 {
    struct Point: Hashable {
        let x, y: Int
    }

    struct DepthMap {
        let data: [[Int]]
        let maxX: Int
        let maxY: Int

        func depthAt(_ point: Point) -> Int {
            data[point.y][point.x]
        }

        func neighbors(for point: Point) -> [Point] {
            var result = [Point]()

            for xoffset in stride(from: -1, through: 1, by: 2) {
                let nx = point.x+xoffset
                if nx >= 0 && nx < maxX {
                    result.append(Point(x: nx, y: point.y))
                }
            }
            for yoffset in stride(from: -1, through: 1, by: 2) {
                let ny = point.y+yoffset
                if ny >= 0 && ny < maxY {
                    result.append(Point(x: point.x, y: ny))
                }
            }
            return result
        }
    }

    static let testData = [
        "2199943210",
        "3987894921",
        "9856789892",
        "8767896789",
        "9899965678"
    ]

    static func run() {
        // let data = testData
        let data = readFile(named: "puzzle9.txt")

        let depthMap = Timer.time(day: 9) { () -> DepthMap in
            let map = data.map { $0.map { Int(String($0))! } }
            return DepthMap(data: map, maxX: map[0].count, maxY: map.count)
        }

        let puzzle = Puzzle9()

        let (riskLevel, lowPoints) = puzzle.part1(depthMap)
        print("Solution for part 1: \(riskLevel)")
        print("Solution for part 2: \(puzzle.part2(depthMap, lowPoints))")
    }

    private func part1(_ depthMap: DepthMap) -> (Int, [Point]) {
        let timer = Timer(day: 9); defer { timer.show() }
        var riskLevel = 0
        var lowPoints = [Point]()
        for y in 0..<depthMap.maxY {
            for x in 0..<depthMap.maxX {
                let point = Point(x: x, y: y)
                let depth = depthMap.depthAt(point)
                var surroundings = [Int]()
                for neighbor in depthMap.neighbors(for: point) {
                    surroundings.append(depthMap.depthAt(neighbor))
                }
                let min = surroundings.min(by: <)!
                if depth < min {
                    lowPoints.append(point)
                    riskLevel += depth + 1
                }
            }
        }

        return (riskLevel, lowPoints)
    }

    private func part2(_ depthMap: DepthMap, _ lowPoints: [Point]) -> Int {
        let timer = Timer(day: 9); defer { timer.show() }
        var basinSizes = [Int]()
        for point in lowPoints {
            let size = findBasinSize(in: depthMap, at: point)
            basinSizes.append(size)
        }

        return basinSizes.sorted(by: >).prefix(3).reduce(1, *)
    }

    private func findBasinSize(in depthMap: DepthMap, at origin: Point) -> Int {
        var visited = Set<Point>()

        findBasinSize(in: depthMap, at: origin, &visited)
        return visited.count
    }

    private func findBasinSize(in depthMap: DepthMap, at origin: Point, _ visited: inout Set<Point>) {
        if visited.contains(origin) {
            return
        }

        visited.insert(origin)
        for neighbor in depthMap.neighbors(for: origin) {
            if depthMap.depthAt(neighbor) == 9 {
                continue
            }
            findBasinSize(in: depthMap, at: neighbor, &visited)
        }
    }
}
