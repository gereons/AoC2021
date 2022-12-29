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

    struct Point: Hashable {
        let x, y: Int
    }

    enum Fold {
        case up(Int)
        case left(Int)
    }

    class Grid {
        private var points: Set<Point>
        private(set) var maxX: Int
        private(set) var maxY: Int

        init(points: [Point], maxX: Int, maxY: Int) {
            self.maxX = maxX
            self.maxY = maxY
            self.points = Set(points)
        }

        func show() {
            for y in 0...maxY {
                for x in 0...maxX {
                    let ch = points.contains(Point(x: x, y: y)) ? "#" : " "
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

        private func foldUp(at yFold: Int) {
            let points = points.filter { $0.x <= maxX && $0.y <= maxY && $0.y > yFold }
            points.forEach {
                let yFolded = abs($0.y - (2 * yFold))
                self.points.insert(Point(x: $0.x, y: yFolded))
            }

            maxY = yFold - 1
        }

        private func foldLeft(at xFold: Int) {
            let points = points.filter { $0.x <= maxX && $0.y <= maxY && $0.x > xFold }
            points.forEach {
                let xFolded = abs($0.x - (2 * xFold))
                self.points.insert(Point(x: xFolded, y: $0.y))
            }

            maxX = xFold - 1
        }

        var visibleDots: Int {
            return points.filter { $0.x <= maxX && $0.y <= maxY }.count
        }
    }

    static func run() {
        // let data = testData
        let data = Self.rawInput.components(separatedBy: "\n")

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
        grid.show() // LRGPRECB
    }

    private func part1and2(_ grid: Grid, _ folds: [Fold]) -> Int {
        let timer = Timer(day: 13); defer { timer.show() }

        var dots = -1
        for fold in folds {
            grid.fold(fold)
            if dots == -1 { dots = grid.visibleDots }
        }

        return dots
    }
}
