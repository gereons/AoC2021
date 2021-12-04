import Foundation

// where do the puzzle input files live relative to $HOME
let fixturePath = "Developer/AdventOfCode/AoC2021/Fixtures"

//Puzzle2.run()
//Puzzle3.run()
//Puzzle1.run()
Puzzle4.run()
// Puzzle5.run()
// Puzzle6.run()
// Puzzle7.run()
// Puzzle8.run()
// Puzzle9.run()
// Puzzle10.run()
// Puzzle11.run()
// Puzzle12.run()
// Puzzle13.run()
// Puzzle14.run()
// Puzzle15.run()
// Puzzle16.run()
// Puzzle17.run()
// Puzzle18.run()
// Puzzle19.run()
// Puzzle20.run()
// Puzzle21.run()
// Puzzle22.run()
// Puzzle23.run()
// Puzzle24.run()
// Puzzle25.run()
Timer.showTotal()

public func readFile(named name: String) -> [String] {
    // relative url, works when running with "swift run"
    var url = URL(fileURLWithPath: "Fixtures/\(name)")
    do {
        _ = try url.checkResourceIsReachable()
    } catch {
        // absolute url, used when running from Xcode
        if let home = ProcessInfo().environment["HOME"] {
            url = URL(fileURLWithPath: "\(home)/\(fixturePath)/\(name)")
        }
    }
    if let data = try? Data(contentsOf: url), let str = String(bytes: data, encoding: .utf8) {
        return str.components(separatedBy: "\n").dropLast()
    }
    print("OOPS: can't read \(url.absoluteURL)")
    return []
}

class Timer {
    private let start = Date().timeIntervalSinceReferenceDate
    private let name: String

    private static var total: TimeInterval = 0

    init(day: Int, fun: StaticString = #function) {
        self.name = "Day \(day) \(fun)"
    }

    func show() {
        let elapsed = Date().timeIntervalSinceReferenceDate - start
        Self.total += elapsed
        print("\(name) took \(elapsed)s")
    }

    static func showTotal() {
        print("Total time: \(Self.total)s")
    }
}
