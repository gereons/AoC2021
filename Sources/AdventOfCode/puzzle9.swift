import Foundation

struct Puzzle9 {
    static let testData = [
        "2199943210",
        "3987894921",
        "9856789892",
        "8767896789",
        "9899965678"
    ]

    static func run() {
        // let data = testData
        let data = readFile(named: "puzzle9.txt")

        let heightMap = Timer.time(day: 9) {
            data.map { $0.map { Int(String($0))! } }
        }

        let puzzle = Puzzle9()

        print("Solution for part 1: \(puzzle.part1(heightMap))")
        // print("Solution for part 2: \(puzzle.part2(data))")
    }

    private func part1(_ heightMap: [[Int]]) -> Int {
        let numRows = heightMap.count
        let numCols = heightMap[0].count
        var riskLevel = 0
        for y in 0..<heightMap.count {
            for x in 0..<heightMap[0].count {
                let height = heightMap[y][x]
                var surroundings = [Int]()
                for neighbor in neighbors(x, y, numCols, numRows) {
                    surroundings.append(heightMap[neighbor.1][neighbor.0])
                }
                let min = surroundings.min(by: <)!
                if height < min {
                    riskLevel += height + 1
                }
            }
        }

        return riskLevel
    }

    private func part2(_ data: [String]) -> Int {
        return 42
    }

    private func neighbors(_ x: Int, _ y: Int, _ maxX: Int, _ maxY: Int) -> [(Int, Int)] {
        var result = [(Int, Int)]()

        for xoffset in stride(from: -1, through: 1, by: 2) {
            let nx = x+xoffset
            if nx >= 0 && nx < maxX {
                result.append((nx, y))
            }
        }
        for yoffset in stride(from: -1, through: 1, by: 2) {
            let ny = y+yoffset
            if ny >= 0 && ny < maxY {
                result.append((x, ny))
            }
        }
        return result
    }
}
