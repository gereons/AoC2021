import Foundation

//    Solution for part 1: 1893605
//    Solution for part 2: 2120734350

enum Puzzle2 {
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
            let components = str.components(separatedBy: " ")
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
        // let data = testData
        let commands = readFile(named: "puzzle2.txt").map { Command(from: $0) }

        print("Solution for part 1: \(part1(commands))")
        print("Solution for part 2: \(part2(commands))")
    }

    static func part1(_ commmands: [Command]) -> Int {
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

    static func part2(_ commands: [Command]) -> Int {
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
