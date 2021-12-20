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

        init(data: [String]) {
            var pixels = [Point: Bool]()
            for (y, line) in data.enumerated() {
                for (x, ch) in line.enumerated() {
                    let point = Point(x: x, y: y)
                    pixels[point] = ch == "#"
                }
            }
            self.pixels = pixels

            let p = Point(x: -10, y: -10)
            print(p.neighbors())
            print(sample(p.neighbors()))
            print()
        }

        init(pixels: [Point: Bool]) {
            self.pixels = pixels
        }

        var minX: Int { pixels.keys.map { $0.x }.min()! }
        var maxX: Int { pixels.keys.map { $0.x }.max()! }
        var minY: Int { pixels.keys.map { $0.y }.min()! }
        var maxY: Int { pixels.keys.map { $0.y }.max()! }

        func enhance(using bits: [Bool]) -> Image {
            var pixels = [Point: Bool]()
            for y in minY-30 ... maxY+30 {
                for x in minX-30 ... maxX+30 {
                    let point = Point(x: x, y: y)
                    let neighbors = point.neighbors()
                    let sampleIndex = sample(neighbors)
                    pixels[point] = bits[sampleIndex]
                }
            }

            return Image(pixels: pixels)
        }

        private func sample(_ points: [Point]) -> Int {
            var value = 0
            for p in points {
                let bit = pixels[p] ?? false
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
                    let pixel = pixels[point]! // ?? false
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

        let data = readFile(named: "puzzle20.txt")

        let (enhanceBits, image) = Timer.time(day: 20) { () -> ([Bool], Image) in
            let enhanceBits = data[0].map { $0 == "#" ? true : false }
            let image = Image(data: Array(data.dropFirst(2)))
            return (enhanceBits, image)
        }

        let puzzle = Puzzle20()

        print("Solution for part 1: \(puzzle.part1(enhanceBits, image))")
        print("Solution for part 2: \(puzzle.part2())")
    }

    private func part1(_ bits: [Bool], _ image: Image) -> Int {
        let timer = Timer(day: 20); defer { timer.show() }

        image.dump()
        var enh = image.enhance(using: bits)
//        print()
//        enh.dump()
//        print(enh.count())
        enh = enh.enhance(using: bits)
//        print()
//        enh.dump()
        return enh.count()
    }

    private func part2() -> Int {
        let timer = Timer(day: 20); defer { timer.show() }
        return 42
    }
}
