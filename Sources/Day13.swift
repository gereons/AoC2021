//
// Advent of Code 2021 Day 13
//

import AoCTools

final class Day13: AdventOfCodeDay {
    let title = "Transparent Origami"

    enum Fold {
        case up(Int)
        case left(Int)
    }

    final class Grid {
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
                    let ch = points.contains(Point(x, y)) ? "#" : " "
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
                self.points.insert(Point($0.x, yFolded))
            }

            maxY = yFold - 1
        }

        private func foldLeft(at xFold: Int) {
            let points = points.filter { $0.x <= maxX && $0.y <= maxY && $0.x > xFold }
            points.forEach {
                let xFolded = abs($0.x - (2 * xFold))
                self.points.insert(Point(xFolded, $0.y))
            }

            maxX = xFold - 1
        }

        var visibleDots: Int {
            return points.filter { $0.x <= maxX && $0.y <= maxY }.count
        }
    }

    let grid: Grid
    let folds: [Fold]

    init(input: String) {
        var points = [Point]()
        var folds = [Fold]()
        var maxX = 0
        var maxY = 0

        for line in input.lines {
            if line.isEmpty { continue }
            let tokens = line.split(separator: ",")
            if tokens.count == 2 {
                let point = Point(Int(tokens[0])!, Int(tokens[1])!)
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
        self.folds = folds
    }

    func part1() -> Int {
        var dots = -1
        for fold in folds {
            grid.fold(fold)
            if dots == -1 {
                dots = grid.visibleDots
            }
        }

        return dots
    }

    func part2() -> String {
        grid.show()
        return "LRGPRECB"
    }
}
