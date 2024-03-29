import Foundation

//    Solution for part 1: 1893605
//    Solution for part 2: 2120734350

struct Puzzle2 {
    static let testData = [
        "forward 5",
        "down 5",
        "forward 8",
        "up 3",
        "down 8",
        "forward 2"
    ]

    enum Command {
        case forward(Int)
        case down(Int)
        case up(Int)

        init(from str: String) {
            let components = str.split(separator: " ")
            let speed = Int(components[1])!

            switch components[0] {
            case "forward": self = .forward(speed)
            case "up": self = .up(speed)
            case "down": self = .down(speed)
            default: fatalError("unknown command \(str)")
            }
        }
    }

    static func run() {
        // let data = Self.testData
        let data = Self.rawInput.components(separatedBy: "\n")

        let commands = Timer.time(day: 2) {
            data.map { Command(from: $0) }
        }

        let puzzle = Puzzle2()

        print("Solution for part 1: \(puzzle.part1(commands))")
        print("Solution for part 2: \(puzzle.part2(commands))")
    }

    private func part1(_ commmands: [Command]) -> Int {
        let timer = Timer(day: 2); defer { timer.show() }
        var position = 0
        var depth = 0
        for command in commmands {
            switch command {
            case .forward(let speed): position += speed
            case .up(let speed): depth -= speed
            case .down(let speed): depth += speed
            }
        }

        return position * depth
    }

    private func part2(_ commands: [Command]) -> Int {
        let timer = Timer(day: 2); defer { timer.show() }
        var position = 0
        var depth = 0
        var aim = 0
        for command in commands {
            switch command {
            case .forward(let speed): position += speed; depth += aim * speed
            case .up(let speed): aim -= speed
            case .down(let speed): aim += speed
            }
        }

        return position * depth
    }
}
