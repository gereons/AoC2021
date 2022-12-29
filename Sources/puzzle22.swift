import Foundation

struct Puzzle22 {
    static let testData = [
        "on x=-20..26,y=-36..17,z=-47..7",
        "on x=-20..33,y=-21..23,z=-26..28",
        "on x=-22..28,y=-29..23,z=-38..16",
        "on x=-46..7,y=-6..46,z=-50..-1",
        "on x=-49..1,y=-3..46,z=-24..28",
        "on x=2..47,y=-22..22,z=-23..27",
        "on x=-27..23,y=-28..26,z=-21..29",
        "on x=-39..5,y=-6..47,z=-3..44",
        "on x=-30..21,y=-8..43,z=-13..34",
        "on x=-22..26,y=-27..20,z=-29..19",
        "off x=-48..-32,y=26..41,z=-47..-37",
        "on x=-12..35,y=6..50,z=-50..-2",
        "off x=-48..-32,y=-32..-16,z=-15..-5",
        "on x=-18..26,y=-33..15,z=-7..46",
        "off x=-40..-22,y=-38..-28,z=23..41",
        "on x=-16..35,y=-41..10,z=-47..6",
        "off x=-32..-23,y=11..30,z=-14..3",
        "on x=-49..-5,y=-3..45,z=-29..18",
        "off x=18..30,y=-20..-8,z=-3..13",
        "on x=-41..9,y=-7..43,z=-33..15",
        "on x=-54112..-39298,y=-85059..-49293,z=-27449..7877",
        "on x=967..23432,y=45373..81175,z=27513..53682"
    ]

    struct Point: Hashable {
        let x,y,z: Int
    }

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

        func points(min: Int, max: Int) -> [Point] {
            let limit = Cube(on: self.on, xMin: min, xMax: max, yMin: min, yMax: max, zMin: min, zMax: max)
            guard let cube = self.intersect(limit, on: self.on) else {
                return []
            }

            var points = [Point]()
            for x in cube.xMin...cube.xMax {
                for y in cube.yMin...cube.yMax {
                    for z in cube.zMin...cube.zMax {
                        points.append(Point(x: x, y: y, z: z))
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

    static func run() {
        // let data = testData
        let data = Self.rawInput.components(separatedBy: "\n")

        let cubes = Timer.time(day: 22) {
            data.map { Cube($0) }
        }

        let puzzle = Puzzle22()

        print("Solution for part 1: \(puzzle.part1(cubes))")
        print("Solution for part 2: \(puzzle.part2(cubes))")
    }

    private func part1(_ cubes: [Cube]) -> Int {
        let timer = Timer(day: 22); defer { timer.show() }

        var reactor = Set<Point>()

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

    private func part2(_ cubes: [Cube]) -> Int {
        let timer = Timer(day: 22); defer { timer.show() }

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
