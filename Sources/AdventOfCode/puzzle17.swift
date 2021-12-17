import Foundation

struct Puzzle17 {

    struct Velocity {
        let dx: Int
        let dy: Int
    }

    struct Target {
        let xRange: ClosedRange<Int>
        let yRange: ClosedRange<Int>
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

        var maxApex = 0
        var velocities = 0
        for dx in 1...target.xRange.upperBound {
            for dy in target.yRange.lowerBound ... -target.yRange.lowerBound {
                if let apex = launchProbe(dx: dx, dy: dy, at: target) {
                    maxApex = max(maxApex, apex)
                    velocities += 1
                }
            }
        }

        return (maxApex, velocities)
    }

    // if target hit, return apex, else nil
    private func launchProbe(dx: Int, dy: Int, at target: Target) -> Int? {
        var x = 0
        var y = 0
        var dx = dx
        var dy = dy

        while x < target.xRange.upperBound && y > target.yRange.lowerBound {
            x += dx
            y += dy
            if dx > 0 { dx -= 1 }
            dy -= 1

            if target.xRange ~= x && target.yRange ~= y {
                return dy * (dy + 1) / 2
            }
        }
        return nil
    }
}
