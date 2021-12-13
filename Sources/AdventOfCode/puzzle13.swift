import Foundation

struct Puzzle13 {
    static let testData = [
        "6,10",
        "0,14",
        "9,10",
        "0,3",
        "10,4",
        "4,11",
        "6,0",
        "6,12",
        "4,1",
        "0,13",
        "10,12",
        "3,4",
        "3,0",
        "8,4",
        "1,10",
        "2,14",
        "8,10",
        "9,0",
        "",
        "fold along y=7",
        "fold along x=5"
    ]

    struct Point {
        let x, y: Int
    }

    enum Fold {
        case up(Int)
        case left(Int)
    }

    class Grid {
        private var points = [[Bool]]()
        private(set) var maxX: Int
        private(set) var maxY: Int

        init(points: [Point], maxX: Int, maxY: Int) {
            self.maxX = maxX
            self.maxY = maxY
            let line = [Bool](repeating: false, count: maxX+1)
            self.points = [[Bool]](repeating: line, count: maxY+1)

            points.forEach {
                self.points[$0.y][$0.x] = true
            }
        }

        func show() {
            for y in 0...maxY {
                for x in 0...maxX {
                    let ch = points[y][x] ? "#" : "."
                    print(ch, terminator: "")
                }
                print()
            }
        }

        func fold(_ fold: Fold) {
            switch fold {
            case .up(let y):
                foldUp(at: y)
            case .left(let x):
                foldLeft(at: x)
            }
        }

        private func foldUp(at y: Int) {
            var destY = 0
            for y in (y+1...maxY).reversed() {
                for x in 0...maxX {
                    points[destY][x] = points[destY][x] || points[y][x]
                }
                destY += 1
            }

            maxY = y - 1
        }

        private func foldLeft(at x: Int) {
            for y in 0...maxY {
                var destX = 0
                for x in (x+1...maxX).reversed() {
                    points[y][destX] = points[y][destX] || points[y][x]
                    destX += 1
                }
            }
            maxX = x - 1
        }

        var visibleDots: Int {
            var sum = 0
            for y in 0...maxY {
                for x in 0...maxX {
                    sum += points[y][x] ? 1 : 0
                }
            }
            return sum
        }
    }

    static func run() {
        // let data = testData
        let data = readFile(named: "puzzle13.txt")

        var points = [Point]()
        var folds = [Fold]()
        var maxX = 0
        var maxY = 0
        var grid = Grid(points: [], maxX: 0, maxY: 0)

        Timer.time(day: 13) {
            for line in data {
                if line.isEmpty { continue }
                let tokens = line.split(separator: ",")
                if tokens.count == 2 {
                    let point = Point(x: Int(tokens[0])!, y: Int(tokens[1])!)
                    points.append(point)
                    maxX = max(maxX, point.x)
                    maxY = max(maxY, point.y)
                } else {
                    let tokens = line.split(separator: "=")
                    switch tokens[0] {
                    case "fold along y": folds.append(.up(Int(tokens[1])!))
                    case "fold along x": folds.append(.left(Int(tokens[1])!))
                    default: fatalError()
                    }
                }
            }
            grid = Grid(points: points, maxX: maxX, maxY: maxY)
        }

        let puzzle = Puzzle13()

        print("Solution for part 1: \(puzzle.part1and2(grid, folds))")
        print("Solution for part 2:")
        grid.show()
        // print("Solution for part 2: \(puzzle.part2(grid, folds))")
    }

    private func part1and2(_ grid: Grid, _ folds: [Fold]) -> Int {
        let timer = Timer(day: 13); defer { timer.show() }

        var dots = -1
        for fold in folds {
            grid.fold(fold)
            if dots == -1 { dots = grid.visibleDots }
        }

        // grid.show()
        // LRGPRECB
        
        return dots
    }
}
