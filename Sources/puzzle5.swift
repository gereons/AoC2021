import Foundation

// Solution for part 1: 7269
// Solution for part 2: 21140

struct Puzzle5 {
    static let testData = [
        "0,9 -> 5,9",
        "8,0 -> 0,8",
        "9,4 -> 3,4",
        "2,2 -> 2,1",
        "7,0 -> 7,4",
        "6,4 -> 2,0",
        "0,9 -> 2,9",
        "3,4 -> 1,4",
        "0,0 -> 8,8",
        "5,5 -> 8,2"
    ]

    struct Point {
        let x, y: Int
    }

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

            let steps = max(deltaX, deltaY)
            return (0...steps).map { d in
                Point(x: start.x + d * stepX, y: start.y + d * stepY)
            }
        }
    }

    static func run() {
        // let data = testData
        let data = Self.rawInput.components(separatedBy: "\n")

        var maxX = 0
        var maxY = 0

        let vectors = Timer.time(day: 5) { () -> [Vector] in
            let regex = try! NSRegularExpression(pattern: #"(\d*),(\d*) -> (\d*),(\d*)"#, options: [])
            return data.map { line -> Vector in
                let range = NSRange(location: 0, length: line.count)
                let match = regex.firstMatch(in: line, options: .anchored, range: range)!
                let x1 = Int(line[Range(match.range(at: 1), in: line)!])!
                let y1 = Int(line[Range(match.range(at: 2), in: line)!])!
                let x2 = Int(line[Range(match.range(at: 3), in: line)!])!
                let y2 = Int(line[Range(match.range(at: 4), in: line)!])!

                maxX = max(maxX, max(x1, x2))
                maxY = max(maxY, max(y1, y2))

                let p1 = Point(x: x1, y: y1)
                let p2 = Point(x: x2, y: y2)
                return Vector(start: p1, end: p2)
            }
        }

        let puzzle = Puzzle5()
        let dim = Point(x: maxX + 1, y: maxY + 1)

        print("Solution for part 1: \(puzzle.part1(vectors, dim))")
        print("Solution for part 2: \(puzzle.part2(vectors, dim))")
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

    private func part1(_ vectors: [Vector], _ max: Point) -> Int {
        let timer = Timer(day: 5); defer { timer.show() }
        let vectors = vectors.filter { !$0.diagonal }
        return findVents(vectors, max)
    }

    private func part2(_ vectors: [Vector], _ max: Point) -> Int {
        let timer = Timer(day: 5); defer { timer.show() }
        return findVents(vectors, max)
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
}
