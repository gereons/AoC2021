// Solution for part 1: 548
// Solution for part 2: 1074888

struct Entry {
    let inputs: [String]
    let outputs: [String]

    init(_ str: String) {
        let s = str.split(separator: "|")
        let inputs = s[0].split(separator: " ").map { String(String($0).sorted()) }
        self.inputs = inputs.sorted { i1, i2 in
            if i1.count != i2.count {
                return i1.count < i2.count
            }
            return i1 < i2
        }
        outputs = s[1].split(separator: " ").map { String(String($0).sorted()) }
        assert(inputs.count == 10)
        assert(outputs.count == 4)
    }
}

struct Puzzle8 {
    static let testData = [
        // "acedgfb cdfbe gcdfa fbcad dab cefabd cdfgeb eafb cagedb ab | cdfeb fcadb cdfeb cdbaf", // -> 5353
        "be cfbegad cbdgef fgaecd cgeb fdcge agebfd fecdb fabcd edb | fdgacbe cefdb cefbgd gcbe",
        "edbfga begcd cbg gc gcadebf fbgde acbgfd abcde gfcbed gfec | fcgedb cgb dgebacf gc",
        "fgaebd cg bdaec gdafb agbcfd gdcbef bgcad gfac gcb cdgabef | cg cg fdcagb cbg",
        "fbegcd cbd adcefb dageb afcb bc aefdc ecdab fgdeca fcdbega | efabcd cedba gadfec cb",
        "aecbfdg fbg gf bafeg dbefa fcge gcbea fcaegb dgceab fcbdga | gecf egdcabf bgf bfgea",
        "fgeab ca afcebg bdacfeg cfaedg gcfdb baec bfadeg bafgc acf | gebdcfa ecba ca fadegcb",
        "dbcfg fgd bdegcaf fgec aegbdf ecdfab fbedc dacgb gdcebf gf | cefg dcbef fcge gbcadfe",
        "bdfegc cbegaf gecbf dfcage bdacg ed bedf ced adcbefg gebcd | ed bcgafe cdgba cbgef",
        "egadfb cdbfeg cegd fecab cgb gbdefca cg fgcdab egfdb bfceg | gbdfcae bgc cg cgb",
        "gcafb gcf dcaebfg ecagb gf abcdeg gaef cafbge fdbac fegbdc | fgae cfgab fg bagce"
    ] // 61129

    static func run() {
        // let data = testData
        let data = readFile(named: "puzzle8.txt")

        let entries = Timer.time(day: 8) {
            data.map { Entry($0) }
        }

        let puzzle = Puzzle8()

        print("Solution for part 1: \(puzzle.part1(entries))")
        print("Solution for part 2: \(puzzle.part2(entries))")
    }

    private func part1(_ entries: [Entry]) -> Int {
        let timer = Timer(day: 8); defer { timer.show() }

        var sum = 0
        for entry in entries {
            for out in entry.outputs {
                switch out.count {
                case 2,3,4,7: sum += 1
                default: ()
                }
            }
        }
        return sum
    }

    private func part2(_ entries: [Entry]) -> Int {
        let timer = Timer(day: 8); defer { timer.show() }

        return entries.reduce(0) { sum, entry in
            sum + decode(entry)
        }
    }

    private func decode(_ entry: Entry) -> Int {
        var digits = [String: Int]()
        var found = [Bool](repeating: false, count: 10)

        // find the unique entries
        let one = entry.inputs[0]
        let seven = entry.inputs[1]
        let four = entry.inputs[2]
        let eight = entry.inputs[9]

        digits[one] = 1
        digits[seven] = 7
        digits[four] = 4
        digits[eight] = 8

        var fourcorner = four
        fourcorner.removeAll { $0 == one.first }
        fourcorner.removeAll { $0 == one.last }

        // find the 5-segment digits (3/5/2)
        let digit5 = entry.inputs[3...5]
        digit5.forEach { str in
            if !found[3] && str.containsAll(one) {
                digits[str] = 3
                found[3] = true
            } else if !found[5] && str.containsAll(fourcorner) {
                digits[str] = 5
                found[5] = true
            } else if !found[2] {
                digits[str] = 2
                found[2] = true
            }
        }

        // find the 6-segment digits (9/0/6)
        let digit6 = entry.inputs[6...8]
        digit6.forEach { str in
            if !found[9] && str.containsAll("\(four)\(seven)") {
                digits[str] = 9
                found[9] = true
            } else if !found[0] && str.containsAll(one) {
                digits[str] = 0
                found[0] = true
            } else if !found[6] {
                digits[str] = 6
                found[6] = true
            }
        }
        assert(digits.count == 10)

        // now match the 4 outputs to 4 digits
        return entry.outputs.reduce(0) { sum, output in
            sum * 10 + digits[output]!
        }

    }
}

private extension String {
    func containsAll(_ string: String) -> Bool {
        let lookupChars = Set(string.map { $0 })
        return lookupChars.isSubset(of: self)
    }
}
