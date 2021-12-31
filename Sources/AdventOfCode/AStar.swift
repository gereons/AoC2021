//
//  AStar.swift
//
//  based on
//  https://www.raywenderlich.com/3011-how-to-implement-a-pathfinding-with-cocos2d-tutorial
//

protocol Coordinate: Hashable {
    var x: Int { get }
    var y: Int { get }

    init(x: Int, y: Int)
}

protocol Pathfinding {
    func neighbors<C: Coordinate>(for: C) -> [C]
    func costToMove<C: Coordinate>(from: C, to: C) -> Int

    func hScore<C: Coordinate>(from: C, to: C) -> Int
}

extension Pathfinding {
    // use manhattan distance as heuristic
    func hScore<C: Coordinate>(from: C, to: C) -> Int {
        abs(to.y - from.y) + abs(to.x - from.x)
    }
}

// MARK: - implementation

private final class PathStep<C: Coordinate>: Hashable, Comparable, CustomDebugStringConvertible {
    let point: C
    var parent: PathStep?

    private(set) var gScore = 0
    var hScore = 0
    var fScore: Int {
        gScore + hScore
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(point)
    }

    init(point: C) {
        self.point = point
    }

    func setParent(_ parent: PathStep, withMoveCost moveCost: Int) {
        // The G score is equal to the parent G score + the cost to move from the parent to it
        self.parent = parent
        self.gScore = parent.gScore + moveCost
    }

    static func ==(lhs: PathStep, rhs: PathStep) -> Bool {
        lhs.point == rhs.point
    }

    static func < (lhs: PathStep, rhs: PathStep) -> Bool {
        lhs.fScore < rhs.fScore
    }

    var debugDescription: String {
        "pos=\(point) g=\(gScore) h=\(hScore) f=\(fScore)"
    }
}

final class AStarPathfinder {
    private let grid: Pathfinding

    init<PF: Pathfinding>(grid: PF) {
        self.grid = grid
    }

    private func insertStep<C: Coordinate>(_ step: PathStep<C>, inOpenSteps openSteps: inout [PathStep<C>]) {
        openSteps.append(step)
        openSteps.sort { $0.fScore <= $1.fScore }
    }

    func shortestPathFrom<C: Coordinate>(_ start: C, to dest: C) -> [C] {
        var closedSteps = Set<PathStep<C>>()
        var openSteps = Heap<PathStep<C>>.minHeap()
        openSteps.insert(PathStep(point: start))

        while !openSteps.isEmpty {
            let currentStep = openSteps.pop()!
            closedSteps.insert(currentStep)

            if currentStep.point == dest {
                var result = [C]()
                var step: PathStep? = currentStep
                while let s = step {
                    result.append(s.point)
                    step = s.parent
                }
                return result.reversed()
            }

            let neighbors = grid.neighbors(for: currentStep.point)
            for point in neighbors {
                let step = PathStep(point: point)
                if closedSteps.contains(step) {
                    continue
                }

                let moveCost = grid.costToMove(from: currentStep.point, to: step.point)

                if let existingIndex = openSteps.firstIndex(of: step) {
                    let step = openSteps[existingIndex]

                    if currentStep.gScore + moveCost < step.gScore {
                        let step = openSteps.delete(at: existingIndex)!
                        step.setParent(currentStep, withMoveCost: moveCost)
                        openSteps.insert(step)
                    }
                } else {
                    step.setParent(currentStep, withMoveCost: moveCost)
                    step.hScore = grid.hScore(from: step.point, to: dest)

                    openSteps.insert(step)
                }
            }
        }

        return []
    }
}
