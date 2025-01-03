//
// Advent of Code 2021 Day 5
//

import AoCTools
import Foundation


final class Day05: AdventOfCodeDay {
    let title = "Hydrothermal Venture"

    struct Vector {
        let start, end: Point

        var diagonal: Bool {
            start.x != end.x && start.y != end.y
        }

        var allPoints: [Point] {
            let deltaX = abs(end.x - start.x)
            let deltaY = abs(end.y - start.y)
            let stepX = (end.x - start.x).signum()
            let stepY = (end.y - start.y).signum()

            let steps = Swift.max(deltaX, deltaY)
            return (0...steps).map { d in
                Point(start.x + d * stepX, start.y + d * stepY)
            }
        }
    }

    let vectors: [Vector]
    let max: Point

    init(input: String) {
        let data = input.lines

        var maxX = 0
        var maxY = 0

        let regex = try! NSRegularExpression(pattern: #"(\d*),(\d*) -> (\d*),(\d*)"#, options: [])
        vectors = data.map { line -> Vector in
            let range = NSRange(location: 0, length: line.count)
            let match = regex.firstMatch(in: line, options: .anchored, range: range)!
            let x1 = Int(line[Range(match.range(at: 1), in: line)!])!
            let y1 = Int(line[Range(match.range(at: 2), in: line)!])!
            let x2 = Int(line[Range(match.range(at: 3), in: line)!])!
            let y2 = Int(line[Range(match.range(at: 4), in: line)!])!

            maxX = Swift.max(maxX, Swift.max(x1, x2))
            maxY = Swift.max(maxY, Swift.max(y1, y2))

            let p1 = Point(x1, y1)
            let p2 = Point(x2, y2)
            return Vector(start: p1, end: p2)
        }

        max = Point(maxX + 1, maxY + 1)
    }

    func part1() -> Int {
        let vectors = vectors.filter { !$0.diagonal }
        return findVents(vectors, max)
    }

    func part2() -> Int {
        findVents(vectors, max)
    }

    private func findVents(_ vectors: [Vector], _ max: Point) -> Int {
        let line = [Int](repeating: 0, count: max.x)
        var grid = [[Int]](repeating: line, count: max.y)

        for vector in vectors {
            draw(vector, in: &grid)
        }
        // show(grid)

        var sum = 0
        for line in grid {
            sum += line.reduce(0) { sum, x in
                sum + (x > 1 ? 1 : 0)
            }
        }
        return sum
    }

    private func draw(_ vector: Vector, in grid: inout [[Int]]) {
        vector.allPoints.forEach { point in
            grid[point.y][point.x] += 1
        }
    }

    private func show(_ grid: [[Int]]) {
        for line in grid {
            for point in line {
                print(point == 0 ? "." : point, terminator: " ")
            }
            print()
        }
    }
}
