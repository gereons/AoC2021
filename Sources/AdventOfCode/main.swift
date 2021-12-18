import Foundation

// where do the puzzle input files live relative to $HOME
let fixturePath = "Developer/AdventOfCode/AoC2021/Fixtures"

//Puzzle1.run()
//Puzzle2.run()
//Puzzle3.run()
//Puzzle4.run()
//Puzzle5.run()
//Puzzle6.run()
//Puzzle7.run()
//Puzzle8.run()
//Puzzle9.run()
//Puzzle10.run()
//Puzzle11.run()
//Puzzle12.run()
//Puzzle13.run()
//Puzzle14.run()
//Puzzle15.run()
//Puzzle16.run()
//Puzzle17.run()
Puzzle18.run()
//Puzzle19.run()
//Puzzle20.run()
//Puzzle21.run()
//Puzzle22.run()
//Puzzle23.run()
//Puzzle24.run()
//Puzzle25.run()
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
        return str.split(separator: "\n", omittingEmptySubsequences: false).dropLast().map { String($0) }
    }
    print("OOPS: can't read \(url.absoluteURL)")
    return []
}

class Timer {
    private let start = Date().timeIntervalSinceReferenceDate
    private let name: String

    private static var total: TimeInterval = 0
    private static let formatter: NumberFormatter = {
        let fmt = NumberFormatter()
        fmt.locale = Locale(identifier: "en_US")
        fmt.maximumFractionDigits = 3
        return fmt
    }()

    init(day: Int, fun: String = #function) {
        self.name = "Day \(day) \(fun)"
    }

    static func time<Result>(day: Int, name: String = "parse", closure: () -> Result) -> Result {
        let timer = Timer(day: day, fun: name)
        defer { timer.show() }
        return closure()
    }

    func show() {
        let elapsed = Date().timeIntervalSinceReferenceDate - start
        Self.total += elapsed
        print("\(name) took \(Self.format(elapsed))ms")
    }

    static func showTotal() {
        print("Total time: \(format(Self.total))ms")
    }

    private static func format(_ time: TimeInterval) -> String {
        formatter.string(for: time * 1000)!
    }
}
