//
// Advent of Code 2021 Day 9
//

import AoCTools

final class Day09: AdventOfCodeDay {
    let title = "Smoke Basin"

    struct DepthMap {
        let data: [[Int]]
        let maxX: Int
        let maxY: Int

        func depthAt(_ point: Point) -> Int {
            data[point.y][point.x]
        }

        func neighbors(for point: Point) -> [Point] {
            var result = [Point]()
            
            for dir in Direction.orthogonal {
                let np = point + dir
                if np.x >= 0 && np.x < maxX && np.y >= 0 && np.y < maxY {
                    result.append(np)
                }
            }

            return result
        }
    }

    let depthMap: DepthMap

    init(input: String) {
        let map = input.lines.map { $0.map { Int(String($0))! } }
        depthMap = DepthMap(data: map, maxX: map[0].count, maxY: map.count)
    }

    func part1() -> Int {
        findRiskLevel().0
    }

    func part2() -> Int {
        var basinSizes = [Int]()
        let lowPoints = findRiskLevel().1
        for point in lowPoints {
            let size = findBasinSize(in: depthMap, at: point)
            basinSizes.append(size)
        }

        return basinSizes.sorted(by: >).prefix(3).reduce(1, *)
    }

    private func findRiskLevel() -> (Int, [Point]) {
        var riskLevel = 0
        var lowPoints = [Point]()
        for y in 0..<depthMap.maxY {
            for x in 0..<depthMap.maxX {
                let point = Point(x, y)
                let depth = depthMap.depthAt(point)
                if depth == 9 {
                    continue
                }
                var minNeighborDepth = Int.max
                for neighbor in depthMap.neighbors(for: point) {
                    let nd = depthMap.depthAt(neighbor)
                    minNeighborDepth = min(minNeighborDepth, nd)
                }
                if depth < minNeighborDepth {
                    lowPoints.append(point)
                    riskLevel += depth + 1
                }
            }
        }

        return (riskLevel, lowPoints)
    }

    private func findBasinSize(in depthMap: DepthMap, at origin: Point) -> Int {
        var visited = Set<Point>()

        findBasinSize(in: depthMap, at: origin, &visited)
        return visited.count
    }

    private func findBasinSize(in depthMap: DepthMap, at point: Point, _ visited: inout Set<Point>) {
        if visited.contains(point) {
            return
        }

        visited.insert(point)
        for neighbor in depthMap.neighbors(for: point) {
            if depthMap.depthAt(neighbor) == 9 {
                continue
            }
            findBasinSize(in: depthMap, at: neighbor, &visited)
        }
    }
}
