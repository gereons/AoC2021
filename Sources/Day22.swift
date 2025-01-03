//
// Advent of Code 2021 Day 22
//

import AoCTools

final class Day22: AdventOfCodeDay {
    let title = "Reactor Reboot"

    struct Cube {
        let on: Bool
        let xMin, xMax: Int
        let yMin, yMax: Int
        let zMin, zMax: Int

        init(on: Bool,
             xMin: Int, xMax: Int,
             yMin: Int, yMax: Int,
             zMin: Int, zMax: Int
        ) {
            self.on = on
            self.xMin = xMin
            self.xMax = xMax
            self.yMin = yMin
            self.yMax = yMax
            self.zMin = zMin
            self.zMax = zMax
        }

        init(_ str: String) {
            var tokens = str.split(separator: " ")
            let on = tokens[0] == "on"
            tokens = tokens[1].split(separator: ",")
            assert(tokens.count == 3)

            let x = Self.range(from: tokens[0])
            let y = Self.range(from: tokens[1])
            let z = Self.range(from: tokens[2])
            self.init(on: on, xMin: x.0, xMax: x.1, yMin: y.0, yMax: y.1, zMin: z.0, zMax: z.1)
        }

        private static func range(from str: String.SubSequence) -> (Int, Int) {
            let tokens = str.dropFirst(2).split(separator: ".")
            let lower = Int(tokens[0])!
            let upper = Int(tokens.last!)!
            return (lower, upper)
        }

        func points(min: Int, max: Int) -> [Point3] {
            let limit = Cube(on: self.on, xMin: min, xMax: max, yMin: min, yMax: max, zMin: min, zMax: max)
            guard let cube = self.intersect(limit, on: self.on) else {
                return []
            }

            var points = [Point3]()
            for x in cube.xMin...cube.xMax {
                for y in cube.yMin...cube.yMax {
                    for z in cube.zMin...cube.zMax {
                        points.append(Point3(x, y, z))
                    }
                }
            }
            return points
        }

        func intersect(_ other: Cube, on: Bool) -> Cube? {
            if
                xMin > other.xMax ||
                xMax < other.xMin ||
                yMin > other.yMax ||
                yMax < other.yMin ||
                zMin > other.zMax ||
                zMax < other.zMin {
                return nil
            }

            return Cube(on: on,
                        xMin: max(xMin, other.xMin), xMax: min(xMax, other.xMax),
                        yMin: max(yMin, other.yMin), yMax: min(yMax, other.yMax),
                        zMin: max(zMin, other.zMin), zMax: min(zMax, other.zMax))
        }

        var volume: Int {
            (xMax - xMin + 1) * (yMax - yMin + 1) * (zMax - zMin + 1)
        }
    }

    let cubes: [Cube]

    init(input: String) {
        // let data = testData
        cubes = input.lines.map { Cube($0) }
    }

    func part1() -> Int {
        var reactor = Set<Point3>()

        for cube in cubes {
            for point in cube.points(min: -50, max: 50) {
                if cube.on {
                    reactor.insert(point)
                } else {
                    reactor.remove(point)
                }
            }
        }

        return reactor.count
    }

    func part2() -> Int {
        var result = [Cube]()

        for cube in cubes {
            var add = [Cube]()
            for other in result {
                if let intersection = cube.intersect(other, on: !other.on) {
                    add.append(intersection)
                }
            }

            result.append(contentsOf: add)
            if cube.on {
                result.append(cube)
            }
        }

        let volume = result.reduce(0) { sum, cube in
            sum + cube.volume * (cube.on ? 1 : -1)
        }

        return volume
    }
}
