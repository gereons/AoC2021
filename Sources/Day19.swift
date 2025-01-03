//
// Advent of Code 2021 Day 19
//

import AoCTools

final class Day19: AdventOfCodeDay {
    let title = "Beacon Scanner"

    struct BeaconMeasurement {
        let points: [Point3]

        init(_ points: [Point3]) {
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
            let points = points.map { $0.rotateX(degrees) }
            return BeaconMeasurement(points)
        }

        func rotateY(_ degrees: Int) -> BeaconMeasurement {
            let points = points.map { $0.rotateY(degrees) }
            return BeaconMeasurement(points)
        }

        func rotateZ(_ degrees: Int) -> BeaconMeasurement {
            let points = points.map { $0.rotateZ(degrees) }
            return BeaconMeasurement(points)
        }

        func matches(_ other: BeaconMeasurement, commonBeacons: Int) -> (BeaconMeasurement, Point3)? {
            var offsets = [Point3: Int]()

            for rotated in other.rotations() {
                let otherPoints = rotated.points

                for point in points {
                    for otherPoint in otherPoints {
                        let offset = otherPoint - point
                        offsets[offset, default: 0] += 1

                        if offsets[offset]! >= commonBeacons {
                            // Swift.print("match at", offset)
                            let adjustedPoints = otherPoints.map { $0 - offset }
                            return (BeaconMeasurement(adjustedPoints), offset)
                        }
                    }
                }
            }
            return nil
        }
    }

    let measurements: [BeaconMeasurement]

    init(input: String) {
        var measurements = [BeaconMeasurement]()
        var points = [Point3]()
        for line in input.lines {
            if !points.isEmpty && line.starts(with: "--") {
                measurements.append(BeaconMeasurement(points))
                points = []
                continue
            }
            let tokens = line.split(separator: ",")
            if tokens.count != 3 { continue }
            points.append(Point3(Int(tokens[0])!, Int(tokens[1])!, Int(tokens[2])!))
        }
        if !points.isEmpty {
            measurements.append(BeaconMeasurement(points))
        }
        self.measurements = measurements
    }

    func part1() -> Int {
        part1and2().0
    }

    func part2() -> Int {
        part1and2().1
    }

    private func part1and2() -> (Int, Int) {
        var allBeacons = Set<Point3>()
        var merged = Set<Int>()
        var origins = [Point3.zero]
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
