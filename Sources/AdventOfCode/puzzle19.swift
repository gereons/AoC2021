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

    struct BeaconMeasurement: Equatable {
        let points: [Point]
        let distances: [Double: Int]

        static func == (lhs: BeaconMeasurement, rhs: BeaconMeasurement) -> Bool {
            Set(lhs.points) == Set(rhs.points)
        }

        init(_ points: [Point]) {
            self.points = points

            var distances = [Double: Int]()
            for i in 0..<points.count-1 {
                for j in i+1 ..< points.count {
                    if i == j {
                        continue
                    }
                    let p1 = points[i]
                    let p2 = points[j]
                    let dx = Double(p1.x-p2.x)
                    let dy = Double(p1.y-p2.y)
                    let dz = Double(p1.z-p2.z)
                    let distance = sqrt(pow(dx, 2) + pow(dy, 2) + pow(dz, 2))
                    distances[distance, default: 0] += 1
                }
            }
            self.distances = distances
        }

        func print() {
            points.forEach {
                Swift.print($0)
            }
        }

        // MARK: - rot
        func rotations() -> [BeaconMeasurement] {
            var result = [0, 90, 180, 270].map { self.rotateY($0) }
            result.append(contentsOf: [90, 180].map { self.rotateZ($0) })

            let x = result.flatMap { s in
                [0, 90, 180, 270].map { s.rotateX($0) }
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
        var origin: Point?
        let measurement: BeaconMeasurement
        private(set) var adjustedMeasurement: BeaconMeasurement?

        init(_ measurement: BeaconMeasurement) {
            self.measurement = measurement
        }

        func matchBeacons(with other: Scanner) {
//            var locations = [Point: Int]()
//            var otherOrigin: Point?
//            var rotatedMeasurement: BeaconMeasurement?
//
//            for p1 in self.measurement.points {
//                let d1 = self.measurement.distances[p1]!
//                for rotated in other.measurement.rotations() {
//                    for (p2, d2) in rotated.distances {
//                        if d2.intersection(d1).count == 11 {
//                            // print("\(p1) matches \(p2)")
//                            // print("scanner is at \(abs(p1.x-p2.x)),\(abs(p1.y-p2.y))")
//                            let scannerLocation = Point(p1.x-p2.x, p1.y-p2.y, p1.z-p2.z)
//                            locations[scannerLocation, default: 0] += 1
//                            if locations[scannerLocation]! >= 12 {
//                                print("scanner is at", scannerLocation)
//                                rotated.print()
//                                otherOrigin = scannerLocation
//                                rotatedMeasurement = rotated
//                            }
//                        }
//                    }
//                }
//            }
//            if let otherOrigin = otherOrigin, let rotatedMeasurement = rotatedMeasurement {
//                print("other is at \(otherOrigin)")
//                other.setOrigin(otherOrigin, relativeTo: self.origin!, matchingMeasurement: rotatedMeasurement)
//            } else {
//                print("other doesn't match")
//            }
        }

        private func setOrigin(_ newOrigin: Point, relativeTo point: Point, matchingMeasurement: BeaconMeasurement) {
            self.origin = newOrigin

            matchingMeasurement.print()

        }
    }

    static func run() {
        // let data = readFile(named: "puzzle19.txt")

        let bm = BeaconMeasurement([
        Point(-1,-1,1),
        Point(-2,-2,2),
        Point(-3,-3,3),
        Point(-2,-3,1),
        Point(5,6,-4),
        Point(8,0,7) ])
        bm.print()

        for (i, rot) in bm.rotations().enumerated() {
            assert(rot.distances == bm.distances)
        }


//        let m = BeaconMeasurement([
//        Point(-1,-1,1),
//        Point(-2,-2,2),
//        Point(-3,-3,3),
//        Point(-2,-3,1),
//        Point(5,6,-4),
//        Point(8,0,7) ])
//
//        let compare = [
//        BeaconMeasurement([
//        Point(1,-1,1),
//        Point(2,-2,2),
//        Point(3,-3,3),
//        Point(2,-1,3),
//        Point(-5,4,-6),
//        Point(-8,-7,0)]),
//        BeaconMeasurement([
//        Point(-1,-1,-1),
//        Point(-2,-2,-2),
//        Point(-3,-3,-3),
//        Point(-1,-3,-2),
//        Point(4,6,5),
//        Point(-7,0,8)]),
//
//        BeaconMeasurement([
//        Point(1,1,-1),
//        Point(2,2,-2),
//        Point(3,3,-3),
//        Point(1,3,-2),
//        Point(-4,-6,5),
//        Point(7,0,8)]),
//
//        BeaconMeasurement([
//        Point(1,1,1),
//        Point(2,2,2),
//        Point(3,3,3),
//        Point(3,1,2),
//        Point(-6,-4,-5),
//        Point(0,7,-8)])]
//
//        m.print()
//        print()
//        var cnt = 0
//        for (i,r) in m.rotations().enumerated() {
//            for c in compare {
//                if c == r {
//                    print(i)
//                    r.print()
//                }
//            }
//        }
//        print(cnt == compare.count)

        let scanners = measurements.map { Scanner($0) }
        scanners[0].origin = Point.zero
        let m0 = scanners[0].measurement
        let m1 = scanners[1].measurement

        let d1 = Set(m0.distances.keys)
        let d2 = Set(m1.distances.keys)
        let i = d1.intersection(d2)
        print(i.count)

        // scanners[0].matchBeacons(with: scanners[1])
//        scanners[0].matchBeacons(with: scanners[2])
//        scanners[0].matchBeacons(with: scanners[3])
//        scanners[1].matchBeacons(with: scanners[4])

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
