import Foundation

enum Puzzle2 {
    static let testData = [
        "forward 5",
        "down 5",
        "forward 8",
        "up 3",
        "down 8",
        "forward 2"
    ]

    static func run() {
        // let data = testData
        let data = readFile(named: "puzzle2.txt")

        print("Solution for part 1: \(part1(data))")
        print("Solution for part 2: \(part2(data))")
    }

    static func part1(_ data: [String]) -> Int {
        var position = 0
        var depth = 0
        for command in data {
            let components = command.components(separatedBy: " ")
            let speed = Int(components[1])!

            switch components[0] {
            case "forward": position += speed
            case "up": depth -= speed
            case "down": depth += speed
            default: fatalError("unknown command")
            }
        }

        return position * depth
    }

    static func part2(_ data: [String]) -> Int {
        var position = 0
        var depth = 0
        var aim = 0
        for command in data {
            let components = command.components(separatedBy: " ")
            let speed = Int(components[1])!

            switch components[0] {
            case "forward": position += speed; depth += aim * speed
            case "up": aim -= speed
            case "down": aim += speed
            default: fatalError("unknown command")
            }
        }

        return position * depth
    }
}
