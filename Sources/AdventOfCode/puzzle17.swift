import Foundation

struct Puzzle17 {

    struct Velocity: Hashable {
        let dx: Int
        let dy: Int
    }

    struct Target {
        let xRange: ClosedRange<Int>
        let yRange: ClosedRange<Int>

        func hit(_ x: Int, _ y: Int) -> Bool {
            xRange ~= x && yRange ~= y
        }
    }

    static let testTarget = Target(xRange: 20 ... 30, yRange: -10 ... -5) // [ "target area: x=20..30, y=-10..-5" ]
    static let realTarget = Target(xRange: 288 ... 330, yRange: -96 ... -50) // target area: x=288..330, y=-96..-50

    static func run() {
        let target = realTarget

        let puzzle = Puzzle17()

        let (apex, count) = puzzle.part1and2(target)
        print("Solution for part 1: \(apex)")
        print("Solution for part 2: \(count)")
    }

    private func part1and2(_ target: Target) -> (Int, Int) {
        let timer = Timer(day: 16); defer { timer.show() }

        var heights = [Int]()
        var velocities = Set<Velocity>()
        for dx in 1...target.xRange.upperBound {
            for dy in target.yRange.lowerBound ... -target.yRange.lowerBound {
                if let height = launchProbe(dx: dx, dy: dy, at: target) {
                    heights.append(height)
                    velocities.insert(Velocity(dx: dx, dy: dy))
                }
            }
        }

        return (heights.max()!, velocities.count)
    }

    private func launchProbe(dx: Int, dy: Int, at target: Target) -> Int? {
        var x = 0
        var y = 0
        var dx = dx
        var dy = dy
        var apex = 0

        while x < target.xRange.upperBound && y > target.yRange.lowerBound {
            x += dx
            y += dy
            apex = max(apex, y)
            if dx != 0 { dx += (dx > 0) ? -1 : 1 }
            dy -= 1

            if target.hit(x, y) {
                return apex
            }
        }
        return nil
    }
}
