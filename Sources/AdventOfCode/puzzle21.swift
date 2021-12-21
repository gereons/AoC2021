import Foundation

struct Puzzle21 {
    static let testData = [ "" ]

    class Player {
        var position: Int
        var score = 0

        init(startAt position: Int) {
            self.position = position
        }

        func move(by points: Int) {
            let target = (position + points - 1) % 10 + 1
            score += target
            position = target
        }
    }

    class DerterministicDie {
        private var lastRoll = 0
        private(set) var rolls = 0

        // roll (1,2,3) / (4,5,6) / (7,8,9) ... and wrap at 100
        func roll3() -> Int {
            rolls += 3
            return nextRoll() + nextRoll() + nextRoll()
        }

        private func nextRoll() -> Int {
            lastRoll += 1
            var roll = lastRoll
            if roll > 100 {
                roll = 1
                lastRoll = 1
            }
            return roll
        }
    }

    class DiracDie {
        // all 27 results of 3d3
        func roll3() -> [Int] {
            [
                3,
                4,4,4,
                5,5,5,5,5,5,
                6,6,6,6,6,6,6,
                7,7,7,7,7,7,
                8,8,8,
                9
            ]
        }
    }

    static func run() {
        var puzzle = Puzzle21()
        print("Solution for part 1: \(puzzle.part1())")
        print("Solution for part 2: \(puzzle.part2())")
    }

    private func part1() -> Int {
        let timer = Timer(day: 21); defer { timer.show() }

        let player1 = Player(startAt: 4)
        let player2 = Player(startAt: 2)
        let die = DerterministicDie()

        var losingScore = 0
        while true {
            let roll1 = die.roll3()
            player1.move(by: roll1)
            // print("p1 move to \(player1.position) score=\(player1.score)")
            if player1.score >= 1000 {
                losingScore = player2.score
                break
            }
            let roll2 = die.roll3()
            player2.move(by: roll2)
            // print("p2 move to \(player2.position) score=\(player2.score)")
            if player2.score >= 1000 {
                losingScore = player1.score
                break
            }
        }

        // print("score \(losingScore) rolls \(die.rolls)")

        return losingScore * die.rolls
    }

    private mutating func part2() -> Int {
        let timer = Timer(day: 21); defer { timer.show() }
        let die = DiracDie()

        let state = State(pos1: 4, pos2: 2, pts1: 0, pts2: 0)
        let (w1, w2) = playPart2(state: state, die: die)

        return max(w1, w2)
    }

    struct State: Hashable {
        let pos1, pos2: Int
        let pts1, pts2: Int
    }

    private var cache = [State: (Int, Int)]()

    private mutating func playPart2(state: State, die: DiracDie) -> (Int, Int) {
        if state.pts2 >= 21 {
            return (0, 1)
        }

        var wins1 = 0
        var wins2 = 0
        for dieRoll in die.roll3() {
            let pos = (state.pos1 + dieRoll - 1) % 10 + 1
            let state = State(pos1: state.pos2, pos2: pos, pts1: state.pts2, pts2: state.pts1 + pos)
            if let (w2, w1) = cache[state] {
                wins1 += w1
                wins2 += w2
            } else {
                let (w2, w1) = playPart2(state: state, die: die)
                wins1 += w1
                wins2 += w2
                cache[state] = (w2, w1)
            }
        }
        return (wins1, wins2)
    }
}
