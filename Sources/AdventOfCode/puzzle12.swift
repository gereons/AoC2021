import Foundation

struct Puzzle12 {
    static let testData1 = [
        // start example -> 10 / 36
        "start-A",
        "start-b",
        "A-c",
        "A-b",
        "b-d",
        "A-end",
        "b-end"
    ]

    static let testData2 = [
        // slightly larger example -> 19 / 103
        "dc-end",
        "HN-start",
        "start-kj",
        "dc-start",
        "dc-HN",
        "LN-dc",
        "HN-end",
        "kj-sa",
        "kj-HN",
        "kj-dc"
    ]

    static let testData3 = [
        // even larger example -> 226 / 3509
        "fs-end",
        "he-DX",
        "fs-he",
        "start-DX",
        "pj-DX",
        "end-zg",
        "zg-sl",
        "zg-pj",
        "pj-he",
        "RW-he",
        "fs-DX",
        "pj-RW",
        "zg-RW",
        "start-pj",
        "he-WI",
        "zg-he",
        "pj-fs",
        "start-RW"
    ]

    struct Cave: Hashable {
        let name: String
        let isSmall: Bool

        init(_ name: String) {
            self.name = name
            self.isSmall = name.first!.isLowercase
        }
    }

    struct Path {
        let from: Cave
        let to: Cave

        init(_ str: String) {
            let tokens = str.split(separator: "-")
            from = Cave(String(tokens[0]))
            to = Cave(String(tokens[1]))
        }

        init(from: Cave, to: Cave) {
            self.from = from
            self.to = to
        }
    }

    static func run() {
        // let data = testData3
        let data = readFile(named: "puzzle12.txt")

        let paths = Timer.time(day: 12) { () -> [Path] in
            var paths = [Path]()
            for line in data {
                let p = Path(line)
                paths.append(p)
                if p.from.name != "start" && p.to.name != "end" {
                    let p2 = Path(from: p.to, to: p.from)
                    paths.append(p2)
                }
            }
            return paths
        }

        let puzzle = Puzzle12()

        print("Solution for part 1: \(puzzle.part1(paths))")
        print("Solution for part 2: \(puzzle.part2(paths))")
    }

    private func part1(_ paths: [Path]) -> Int {
        let timer = Timer(day: 12); defer { timer.show() }
        let start = paths.first { $0.from.name == "start" }!.from
        let end = paths.first { $0.to.name == "end" }!.to
        let dfs = DFS(paths: paths)
        dfs.findAll(from: start, to: end)
        return dfs.simplePaths.count
    }

    private func part2(_ paths: [Path]) -> Int {
        let timer = Timer(day: 12); defer { timer.show() }

        var allCaves = Set(paths.flatMap { [$0.from, $0.to ] })
        let start = allCaves.first { $0.name == "start" }!
        let end = allCaves.first { $0.name == "end" }!
        allCaves.remove(start)
        allCaves.remove(end)
        let smallCaves = allCaves.filter { $0.isSmall }

        var resultPaths = Set<[Cave]>()
        smallCaves.forEach {
            let dfs = DFS(paths: paths, allowTwoVisits: $0)
            dfs.findAll(from: start, to: end)
            resultPaths.formUnion(dfs.simplePaths)
        }

        return resultPaths.count
    }

    class DFS {
        private var visited = [Cave: Int]()
        private var currentPath = [Cave]()
        private(set) var simplePaths = [[Cave]]()
        private let paths: [Path]
        private var allowTwoVisits: Cave?

        init(paths: [Path], allowTwoVisits: Cave? = nil) {
            self.paths = paths
            self.allowTwoVisits = allowTwoVisits
        }

        private func visited(_ cave: Cave) -> Bool {
            if cave == allowTwoVisits {
                return cave.isSmall && visited[cave, default: 0] > 1
            } else {
                return cave.isSmall && visited[cave] == 1
            }
        }

        func findAll(from: Cave, to: Cave) {
            if visited(from) {
                return
            }

            visited[from, default: 0] += 1
            currentPath.append(from)
            if from == to {
                simplePaths.append(currentPath)
                visited[from]! -= -1
                currentPath.removeLast()
                return
            }
            for next in paths.filter({ $0.from == from}) {
                findAll(from: next.to, to: to)
            }
            currentPath.removeLast()
            visited[from]! -= 1
        }
    }

}
