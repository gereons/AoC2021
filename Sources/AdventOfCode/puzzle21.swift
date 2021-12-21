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
            var target = position + points
            while target > 10 {
                target -= 10
            }
            score += target
            position = target
        }
    }

    class DerterministicDie {
        private var lastRoll = 0
        private(set) var rolls = 0

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

    static func run() {
        let puzzle = Puzzle21()
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
                // print("p1 win")
                losingScore = player2.score
                break
            }
            let roll2 = die.roll3()
            player2.move(by: roll2)
            // print("p2 move to \(player2.position) score=\(player2.score)")
            if player2.score >= 1000 {
                // print("p2 win")
                losingScore = player1.score
                break
            }
        }

        print("score \(losingScore) rolls \(die.rolls)")

        return losingScore * die.rolls
    }

    private func part2() -> Int {
        let timer = Timer(day: 21); defer { timer.show() }
        return 42
    }
}
