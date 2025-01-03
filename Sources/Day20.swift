//
// Advent of Code 2021 Day 20
//

import AoCTools

final class Day20: AdventOfCodeDay {
    let title = "Trench Map"

    struct Image {
        let pixels: [Point: Bool]
        let backgroundLit: Bool
        private var minX: Int
        private var maxX: Int
        private var minY: Int
        private var maxY: Int

        init(pixels: [Point: Bool], backgroundLit: Bool) {
            self.pixels = pixels
            self.backgroundLit = backgroundLit

            minX = pixels.keys.map { $0.x }.min()!
            maxX = pixels.keys.map { $0.x }.max()!
            minY = pixels.keys.map { $0.y }.min()!
            maxY = pixels.keys.map { $0.y }.max()!
        }

        static func pixels(from data: [String]) -> [Point: Bool] {
            var pixels = [Point: Bool]()
            for (y, line) in data.enumerated() {
                for (x, ch) in line.enumerated() {
                    if ch == "#" {
                        pixels[Point(x, y)] = true
                    }
                }
            }

            return pixels
        }

        func enhance(using bits: [Bool]) -> Image {
            var pixels = [Point: Bool]()
            for y in minY-2 ... maxY+2 {
                for x in minX-2 ... maxX+2 {
                    let point = Point(x, y)
                    let neighbors = (point.self.neighbors(adjacency: .all) + [point]).sorted()
                    let sampleIndex = sample(neighbors)
                    pixels[point] = bits[sampleIndex]
                }
            }

            var backgroundLit = self.backgroundLit
            if bits[0] && bits.last == false {
                backgroundLit.toggle()
            }

            return Image(pixels: pixels, backgroundLit: backgroundLit)
        }

        private func sample(_ points: [Point]) -> Int {
            var value = 0
            for p in points {
                let bit = pixels[p] ?? backgroundLit
                value <<= 1
                value |= bit ? 1 : 0
            }
            return value
        }

        func count() -> Int {
            var count = 0
            for y in minY...maxY {
                for x in minX ... maxX {
                    let point = Point(x, y)
                    count += (pixels[point] ?? false) ? 1 : 0
                }
            }
            return count
        }

        func dump() {
            for y in minY...maxY {
                for x in minX ... maxX {
                    let point = Point(x, y)
                    let pixel = pixels[point] ?? false
                    print(pixel ? "#" : ".", terminator: "")
                }
                print()
            }
        }
    }

    let bits: [Bool]
    let pixels: [Point: Bool]

    init(input: String) {
        let lines = input.lines
        bits = lines[0].map { $0 == "#" ? true : false }
        pixels = Image.pixels(from: Array(lines.dropFirst(2)))
    }

    func part1() -> Int {
        enhance(times: 2)
    }

    func part2() -> Int {
        enhance(times: 50)
    }

    private func enhance(times: Int) -> Int {
        var image = Image(pixels: pixels, backgroundLit: false)
        for _ in 0..<times {
            image = image.enhance(using: bits)
        }
        return image.count()
    }
}
