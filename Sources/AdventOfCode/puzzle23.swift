import Foundation

struct Puzzle23 {
    static let testData = [ "" ]

    enum Pod: String, Hashable {
        case A, B, C, D, Empty = "."

        var energy: Int {
            switch self {
            case .A: return 1
            case .B: return 10
            case .C: return 100
            case .D: return 1000
            case .Empty: fatalError()
            }
        }

        var roomIndex: Int {
            switch self {
            case .A: return 2
            case .B: return 4
            case .C: return 6
            case .D: return 8
            default: fatalError()
            }
        }

        func canMoveTo(_ room: [Pod]) -> Bool {
            for p in room {
                if p != self && p != .Empty {
                    return false
                }
            }
            return true
        }

        func canMoveFrom(_ room: [Pod]) -> Bool {
            for p in room {
                if p != self && p != .Empty {
                    return true
                }
            }
            return false
        }
    }

    class State: Hashable {
        private static var cache = [State: Int]()

        private var rooms: [Pod: [Pod]]
        private var hallway: [Pod]

        init(_ rooms: [Pod: [Pod]], _ hallway: [Pod]) {
            self.rooms = rooms
            self.hallway = hallway
        }

        private func firstOccupiedIndex(in array: [Pod]) -> Int? {
            for (index, pod) in array.enumerated() {
                if pod != .Empty {
                    return index
                }
            }
            return nil
        }

        // dest_idx
        private func lastEmptyIndex(in array: [Pod]) -> Int? {
            for (index, pod) in array.enumerated().reversed() {
                if pod == .Empty {
                    return index
                }
            }
            return nil
        }

        // true if `a` is between room's position and top
        // (regardless of how room and top are ordered
        private func isBetween(_ a: Int, _ room: Pod, _ top: Int) -> Bool {
            // 0 1 A 3 B 5 C 7 D 9 10
            let ri = room.roomIndex
            return
                (ri < a && a < top)
                ||
                (top < a && a < ri)
        }

        private func pathIsClear(_ room: Pod, _ topIndex: Int, _ hallway: [Pod]) -> Bool {
            for index in 0..<hallway.count {
                if isBetween(index, room, topIndex) && hallway[index] != .Empty {
                    return false
                }
            }
            return true
        }

        func show() {
            var counter = [Pod?: Int]()
            for h in hallway {
                print(h.rawValue, terminator: " ")
                counter[h, default: 0] += 1
            }
            print()

            for idx in 0 ..< rooms[.A]!.count {
                print("    ", terminator: "")
                for room in [Pod.A, .B, .C, .D] {
                    let p = rooms[room]![idx]
                    print(p.rawValue, terminator: "   ")
                    counter[p, default: 0] += 1
                }
                print()
            }
            print()
            let r = rooms[.A]!.count
            assert(counter[.A] == r)
            assert(counter[.B] == r)
            assert(counter[.C] == r)
            assert(counter[.D] == r)
            assert(counter[.Empty] == 11)
            assert(hallway[2] == .Empty)
            assert(hallway[4] == .Empty)
            assert(hallway[6] == .Empty)
            assert(hallway[8] == .Empty)
        }

        func done() -> Bool {
            for (room, pods) in rooms {
                for pod in pods {
                    if pod != room {
                        return false
                    }
                }
            }
            return true
        }

        // given this state, return the cost to reach "done
        func cost() -> Int {
            if done() {
                return 0
            }

            if let cost = Self.cache[self] {
                return cost
            }

            for (index, pod) in hallway.enumerated() {
                if let room = rooms[pod], pod.canMoveTo(room) {
                    if pathIsClear(pod, index, hallway) {
                        let roomDistance = lastEmptyIndex(in: room)!
                        let totalDistance = roomDistance + 1 + abs(pod.roomIndex - index)
                        var newHallway = hallway
                        newHallway[index] = .Empty
                        hallway[index] = .Empty
                        var newRooms = rooms
                        newRooms[pod]![roomDistance] = pod
                        let newState = State(newRooms, newHallway)
                        return totalDistance * pod.energy + newState.cost()
                    }
                }
            }

            var minEnergy = Int.max / 2

            for (pod, room) in rooms {
                if !pod.canMoveFrom(room) {
                    continue
                }
                guard let occupiedIndex = firstOccupiedIndex(in: room) else {
                    continue
                }

                let movingPod = room[occupiedIndex]
                for to in 0..<hallway.count {
                    if [2,4,6,8].contains(to) { continue }
                    if hallway[to] != .Empty { continue }
                    if pathIsClear(pod, to, hallway) {
                        let dist = occupiedIndex + 1 + abs(to - pod.roomIndex)
                        var newHallway = hallway
                        assert(newHallway[to] == .Empty)
                        newHallway[to] = movingPod
                        var newRooms = rooms
                        assert(newRooms[pod]![occupiedIndex] == movingPod)
                        newRooms[pod]![occupiedIndex] = .Empty
                        let newState = State(newRooms, newHallway)
                        minEnergy = min(minEnergy, (dist * movingPod.energy) + newState.cost())
                    }
                }
            }
            Self.cache[self] = minEnergy
            return minEnergy
        }

        // MARK: - Hashable
        func hash(into hasher: inout Hasher) {
            hasher.combine(rooms)
            hasher.combine(hallway)
        }

        static func == (lhs: State, rhs: State) -> Bool {
            return lhs.rooms == rhs.rooms && lhs.hallway == rhs.hallway
        }
    }

    static func run() {
        let puzzle = Puzzle23()

        print("Solution for part 1: \(puzzle.part1())")
        print("Solution for part 2: \(puzzle.part2())")
    }

    private func part1() -> Int {
        let timer = Timer(day: 23); defer { timer.show() }

//        let testRooms: [Pod: [Pod]] = [
//            .A: [.B, .A],
//            .B: [.C, .D],
//            .C: [.B, .C],
//            .D: [.D, .A]
//        ]
        let rooms: [Pod: [Pod]] = [
            .A: [.A, .D],
            .B: [.C, .D],
            .C: [.B, .A],
            .D: [.B, .C]
        ]

        let state = State(rooms, [Pod](repeating: .Empty, count: 11))
        return state.cost()
    }

    private func part2() -> Int {
        let timer = Timer(day: 23); defer { timer.show() }

//        let testRooms: [Pod: [Pod]] = [
//            .A: [.B, .D, .D, .A],
//            .B: [.C, .C, .B, .D],
//            .C: [.B, .B, .A, .C],
//            .D: [.D, .A, .C, .A]
//        ]
        let rooms: [Pod: [Pod]] = [
            .A: [.A, .D, .D, .D],
            .B: [.C, .C, .B, .D],
            .C: [.B, .B, .A, .A],
            .D: [.B, .A, .C, .C]
        ]

        let state = State(rooms, [Pod](repeating: .Empty, count: 11))
        return state.cost()
    }
}
