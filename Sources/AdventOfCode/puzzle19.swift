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
    }

    class Scanner {
        let measurement: BeaconMeasurement
        private(set) var adjustedMeasurement: BeaconMeasurement?
        var origin: Point?

        init(_ measurement: BeaconMeasurement) {
            self.measurement = measurement
        }

        func findMatch(with other: Scanner, commonBeacons: Int) {
            let points = self.measurement.points

            var offsets = [Point: Int]()
            var matchingOffset: Point?
            var rotatedMeasurement: BeaconMeasurement?
            for rotated in other.measurement.rotations() {
                let otherPoints = rotated.points

                for point in points {
                    for otherPoint in otherPoints {
                        let dx = otherPoint.x - point.x
                        let dy = otherPoint.y - point.y
                        let dz = otherPoint.z - point.z
                        let offset = Point(dx, dy, dz)
                        offsets[offset, default: 0] += 1

                        if offsets[offset]! >= commonBeacons {
                            matchingOffset = offset
                            rotatedMeasurement = rotated
                        }
                    }
                }
            }
            if let matchingOffset = matchingOffset, let rotatedMeasurement = rotatedMeasurement {
                print("match at", matchingOffset)
                let x = Point(
                    matchingOffset.x - self.origin!.x,
                    matchingOffset.y - self.origin!.y,
                    matchingOffset.z - self.origin!.z)
                print(x)
                let adjustedPoints =
                    rotatedMeasurement.points.map {
                        Point($0.x + matchingOffset.x - self.origin!.x,
                              $0.y + matchingOffset.y - self.origin!.y,
                              $0.z + matchingOffset.z - self.origin!.z)
                    }
                other.adjustedMeasurement = BeaconMeasurement(adjustedPoints)
                other.origin = matchingOffset
            } else {
                print("no match")
            }
        }

        private func setOrigin(_ newOrigin: Point, relativeTo point: Point, matchingMeasurement: BeaconMeasurement) {
            self.origin = newOrigin
        }
    }

    static func run() {
        // let data = readFile(named: "puzzle19.txt")

        let scanners = measurements.map { Scanner($0) }
        scanners[0].origin = Point.zero

        scanners[0].findMatch(with: scanners[1], commonBeacons: 12)
        scanners[1].findMatch(with: scanners[4], commonBeacons: 12)
        scanners[4].findMatch(with: scanners[2], commonBeacons: 12)
        scanners[1].findMatch(with: scanners[3], commonBeacons: 12)

        var points = Set<Point>()
        for s in scanners {
            if let p = s.adjustedMeasurement {
                points.formUnion(p.points)
            } else {
                points.formUnion(s.measurement.points)
            }
        }

        print(points.count)

//        let puzzle = Puzzle19()
//
//        print("Solution for part 1: \(puzzle.part1(data))")
//        print("Solution for part 2: \(puzzle.part2(data))")
    }

    private func part1(_ data: [String]) -> Int {
        let timer = Timer(day: 19); defer { timer.show() }
        return 42
    }

    private func part2(_ data: [String]) -> Int {
        let timer = Timer(day: 19); defer { timer.show() }
        return 42
    }
}
