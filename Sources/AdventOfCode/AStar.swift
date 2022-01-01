//
//  AStar.swift
//
//  based on
//  https://www.raywenderlich.com/3011-how-to-implement-a-pathfinding-with-cocos2d-tutorial
//

protocol Pathfinding {
    associatedtype Coordinate

    func neighbors(for: Coordinate) -> [Coordinate]
    func costToMove(from: Coordinate, to: Coordinate) -> Int

    func hScore(from: Coordinate, to: Coordinate) -> Int
}

//extension Pathfinding where Coordinate == Point {
//    // use manhattan distance as heuristic
//    func hScore(from: Coordinate, to: Coordinate) -> Int {
//        abs(to.y - from.y) + abs(to.x - from.x)
//    }
//}

// MARK: - implementation


final class AStarPathfinder<PF: Pathfinding> where PF.Coordinate: Hashable {
    typealias Coord = PF.Coordinate

    private let grid: PF

    init(grid: PF) {
        self.grid = grid
    }

    func shortestPathFrom(_ start: Coord, to dest: Coord) -> [Coord] {
        var closedSteps = Set<PathStep>()
        var openSteps = Heap<PathStep>.minHeap()
        openSteps.insert(PathStep(coordinate: start))

        while !openSteps.isEmpty {
            let currentStep = openSteps.pop()!
            closedSteps.insert(currentStep)

            if currentStep.coordinate == dest {
                var result = [Coord]()
                var step: PathStep? = currentStep
                while let s = step {
                    result.append(s.coordinate)
                    step = s.parent
                }
                return result.reversed()
            }

            let neighbors = grid.neighbors(for: currentStep.coordinate)
            for coordinate in neighbors {
                let step = PathStep(coordinate: coordinate)
                if closedSteps.contains(step) {
                    continue
                }

                let moveCost = grid.costToMove(from: currentStep.coordinate, to: step.coordinate)

                if let existingIndex = openSteps.firstIndex(of: step) {
                    let step = openSteps[existingIndex]

                    if currentStep.gScore + moveCost < step.gScore {
                        let step = openSteps.delete(at: existingIndex)!
                        step.setParent(currentStep, withMoveCost: moveCost)
                        openSteps.insert(step)
                    }
                } else {
                    step.setParent(currentStep, withMoveCost: moveCost)
                    step.hScore = grid.hScore(from: step.coordinate, to: dest)

                    openSteps.insert(step)
                }
            }
        }

        return []
    }

    private final class PathStep: Hashable, Comparable, CustomDebugStringConvertible {
        let coordinate: Coord
        var parent: PathStep?

        private(set) var gScore = 0
        var hScore = 0
        var fScore: Int {
            gScore + hScore
        }

        init(coordinate: Coord) {
            self.coordinate = coordinate
        }

        func setParent(_ parent: PathStep, withMoveCost moveCost: Int) {
            // The G score is equal to the parent G score + the cost to move from the parent to it
            self.parent = parent
            self.gScore = parent.gScore + moveCost
        }

        // equatable
        static func ==(lhs: PathStep, rhs: PathStep) -> Bool {
            lhs.coordinate == rhs.coordinate
        }

        // hashable
        func hash(into hasher: inout Hasher) {
            hasher.combine(coordinate)
        }

        // comparable
        static func < (lhs: PathStep, rhs: PathStep) -> Bool {
            lhs.fScore < rhs.fScore
        }

        var debugDescription: String {
            "pos=\(coordinate) g=\(gScore) h=\(hScore) f=\(fScore)"
        }
    }

}
