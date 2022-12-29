import Foundation

struct Puzzle20 {
    static let testData = [ "" ]

    struct Point: Hashable {
        let x, y: Int

        func neighbors() -> [Point] {
            var n = [Point]()
            for yOffset in -1...1 {
                for xOffset in -1...1 {
                    let p = Point(x: x+xOffset, y: y+yOffset)
                    n.append(p)
                }
            }
            return n
        }
    }

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
                    let point = Point(x: x, y: y)
                    if ch == "#" {
                        pixels[point] = true
                    }
                }
            }

            return pixels
        }

        func enhance(using bits: [Bool]) -> Image {
            var pixels = [Point: Bool]()
            for y in minY-2 ... maxY+2 {
                for x in minX-2 ... maxX+2 {
                    let point = Point(x: x, y: y)
                    let neighbors = point.neighbors()
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
                    let point = Point(x: x, y: y)
                    count += (pixels[point] ?? false) ? 1 : 0
                }
            }
            return count
        }

        func dump() {
            for y in minY...maxY {
                for x in minX ... maxX {
                    let point = Point(x: x, y: y)
                    let pixel = pixels[point] ?? false
                    print(pixel ? "#" : ".", terminator: "")
                }
                print()
            }
        }
    }

    static func run() {
//        let enhanceInput = "..#.#..#####.#.#.#.###.##.....###.##.#..###.####..#####..#....#..#..##..###..######.###...####..#..#####..##..#.#####...##.#.#..#.##..#.#......#.###.######.###.####...#.##.##..#..#..#####.....#.#....###..#.##......#.....#..#..#..##..#...##.######.####.####.#.#...#.......#..#.#.#...####.##.#......#..#...##.#.##..#...##.#.##..###.#......#.#.......#.#.#.####.###.##...#.....####.#..#..#.##.#....##..#.####....##...##..#...#......#.#.......#.......##..####..#...#.#.#...##..#.#..###..#####........#..####......#..#"
//        let enhanceBits = enhanceInput.map { $0 == "#" ? true : false }
//        let imageInput = [
//            "#..#.",
//            "#....",
//            "##..#",
//            "..#..",
//            "..###"
//        ]
//        let image = Image(data: imageInput)

        let data = Self.rawInput.components(separatedBy: "\n")

        let (enhanceBits, pixels) = Timer.time(day: 20) { () -> ([Bool], [Point: Bool]) in
            let enhanceBits = data[0].map { $0 == "#" ? true : false }
            let pixels = Image.pixels(from: Array(data.dropFirst(2)))
            return (enhanceBits, pixels)
        }

        let puzzle = Puzzle20()

        print("Solution for part 1: \(puzzle.part1(enhanceBits, pixels))")
        print("Solution for part 2: \(puzzle.part2(enhanceBits, pixels))")
    }

    private func part1(_ bits: [Bool], _ pixels: [Point: Bool]) -> Int {
        let timer = Timer(day: 20); defer { timer.show() }
        var image = Image(pixels: pixels, backgroundLit: false)
        for _ in 0..<2 {
            image = image.enhance(using: bits)
        }
        return image.count()
    }

    private func part2(_ bits: [Bool], _ pixels: [Point: Bool]) -> Int {
        let timer = Timer(day: 20); defer { timer.show() }
        var image = Image(pixels: pixels, backgroundLit: false)
        for _ in 0..<50 {
            image = image.enhance(using: bits)
        }
        return image.count()
    }
}
