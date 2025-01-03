//
// Advent of Code 2021 Day 2
//

import AoCTools

final class Day02: AdventOfCodeDay {
    let title: String = "Dive!"

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

    let commands: [Command]

    init(input: String) {
        commands = input.lines.map { Command(from: $0) }
    }

    func part1() -> Int {
        var position = 0
        var depth = 0
        for command in commands {
            switch command {
            case .forward(let speed): position += speed
            case .up(let speed): depth -= speed
            case .down(let speed): depth += speed
            }
        }

        return position * depth
    }

    func part2() -> Int {
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
