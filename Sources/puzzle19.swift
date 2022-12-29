import Foundation

struct Puzzle19 {
    static let testData = [ "" ]

    struct Point: Hashable, CustomStringConvertible {
        let x,y,z: Int

        static let zero = Point(0,0,0)

        init(_ x: Int, _ y: Int, _ z: Int) {
            self.x = x
            self.y = y
            self.z = z
        }

        var description: String {
            // "(x=\(x),y=\(y),z=\(z)"
            "\(x),\(y),\(z)"
        }

        func rotateX_3d(_ degrees: Int) -> Point {
            /*
             |1     0           0| |x|   |        x        |   |x'|
             |0   cos θ    −sin θ| |y| = |y cos θ − z sin θ| = |y'|
             |0   sin θ     cos θ| |z|   |y sin θ + z cos θ|   |z'|
             */
            let xNew = x
            let yNew = y * cos(degrees) - z * sin(degrees)
            let zNew = y * sin(degrees) + z * cos(degrees)
            return Point(xNew, yNew, zNew)
        }

        func rotateY_3d(_ degrees: Int) -> Point {
            /*
             | cos θ    0   sin θ| |x|   | x cos θ + z sin θ|   |x'|
             |   0      1       0| |y| = |         y        | = |y'|
             |−sin θ    0   cos θ| |z|   |−x sin θ + z cos θ|   |z'|
             */
            let xNew = x * cos(degrees) + z * sin(degrees)
            let yNew = y
            let zNew = -x * sin(degrees) + z * cos(degrees)
            return Point(xNew, yNew, zNew)
        }

        func rotateZ_3d(_ degrees: Int) -> Point {
            /*
             |cos θ   −sin θ   0| |x|   |x cos θ − y sin θ|   |x'|
             |sin θ    cos θ   0| |y| = |x sin θ + y cos θ| = |y'|
             |  0       0      1| |z|   |        z        |   |z'|
             */
            let xNew = x * cos(degrees) - y * sin(degrees)
            let yNew = x * sin(degrees) + y * cos(degrees)
            let zNew = z
            return Point(xNew, yNew, zNew)
        }

        private func sin(_ degrees: Int) -> Int {
            switch degrees {
            case 0: return 0
            case 90: return 1
            case 180: return 0
            case 270: return -1
            default: fatalError()
            }
        }

        private func cos(_ degrees: Int) -> Int {
            switch degrees {
            case 0: return 1
            case 90: return 0
            case 180: return -1
            case 270: return 0
            default: fatalError()
            }
        }

        func distance(to point: Point) -> Int {
            let dx = abs(x - point.x)
            let dy = abs(y - point.y)
            let dz = abs(z - point.z)
            return dx + dy + dz
        }
    }

    struct BeaconMeasurement {
        let points: [Point]

        init(_ points: [Point]) {
            self.points = points
        }

        func print() {
            points.forEach {
                Swift.print($0)
            }
        }

        // MARK: - rot
        func rotations() -> [BeaconMeasurement] {
            var result = [0, 90, 180, 270].map { self.rotateX($0) }
            result.append(contentsOf: [90, 270].map { self.rotateY($0) })

            let x = result.flatMap { s in
                [0, 90, 180, 270].map { s.rotateZ($0) }
            }
            assert(x.count == 24)
            return x
        }

        func rotateX(_ degrees: Int) -> BeaconMeasurement {
            let points = points.map { $0.rotateX_3d(degrees) }
            return BeaconMeasurement(points)
        }

        func rotateY(_ degrees: Int) -> BeaconMeasurement {
            let points = points.map { $0.rotateY_3d(degrees) }
            return BeaconMeasurement(points)
        }

        func rotateZ(_ degrees: Int) -> BeaconMeasurement {
            let points = points.map { $0.rotateZ_3d(degrees) }
            return BeaconMeasurement(points)
        }

        func matches(_ other: BeaconMeasurement, commonBeacons: Int) -> (BeaconMeasurement, Point)? {
            var offsets = [Point: Int]()

            for rotated in other.rotations() {
                let otherPoints = rotated.points

                for point in points {
                    for otherPoint in otherPoints {
                        let dx = otherPoint.x - point.x
                        let dy = otherPoint.y - point.y
                        let dz = otherPoint.z - point.z
                        let offset = Point(dx, dy, dz)
                        offsets[offset, default: 0] += 1

                        if offsets[offset]! >= commonBeacons {
                            // Swift.print("match at", offset)

                            let adjustedPoints =
                                otherPoints.map {
                                    Point($0.x - offset.x,
                                          $0.y - offset.y,
                                          $0.z - offset.z)
                                }
                            return (BeaconMeasurement(adjustedPoints), offset)
                        }
                    }
                }
            }
            return nil
        }
    }

    static func run() {
        let data = Self.rawInput.components(separatedBy: "\n")

        let measurements = Timer.time(day: 19) { () -> [BeaconMeasurement] in
            var m = [BeaconMeasurement]()
            var points = [Point]()
            for line in data {
                if !points.isEmpty && line.starts(with: "--") {
                    m.append(BeaconMeasurement(points))
                    points = []
                    continue
                }
                let tokens = line.split(separator: ",")
                if tokens.count != 3 { continue }
                points.append(Point(Int(tokens[0])!, Int(tokens[1])!, Int(tokens[2])!))
            }
            if !points.isEmpty {
                m.append(BeaconMeasurement(points))
            }

            return m
        }

        let puzzle = Puzzle19()

        let (count, distance) = puzzle.part1and2(measurements)
        print("Solution for part 1: \(count)")
        print("Solution for part 2: \(distance)")
    }

    private func part1and2(_ measurements: [BeaconMeasurement]) -> (Int, Int) {
        let timer = Timer(day: 19); defer { timer.show() }

        var allBeacons = Set<Point>()
        var merged = Set<Int>()
        var origins = [Point.zero]
        allBeacons.formUnion(measurements[0].points)

        while merged.count < measurements.count - 1 {
            for i in 1 ..< measurements.count {
                if merged.contains(i) {
                    continue
                }

                let origin = BeaconMeasurement(Array(allBeacons))
                if let (match, origin) = origin.matches(measurements[i], commonBeacons: 12) {
                    allBeacons.formUnion(match.points)
                    merged.insert(i)
                    origins.append(origin)
                    // print("merged", i, allBeacons.count)
                }
            }
        }

        var maxDistance = 0
        for i in 0..<origins.count - 1 {
            for j in i+1..<origins.count {
                let distance = origins[i].distance(to: origins[j])
                maxDistance = max(maxDistance, distance)
            }
        }

        return (allBeacons.count, maxDistance)
    }
}
