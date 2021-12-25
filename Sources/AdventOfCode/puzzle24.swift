import Foundation

struct Puzzle24 {
    static let testData = [
        "inp w",
        "add z w",
        "mod z 2",
        "div w 2",
        "add y w",
        "mod y 2",
        "div w 2",
        "add x w",
        "mod x 2",
        "div w 2",
        "mod w 2"
    ]

    enum Opcode: String {
        case inp, add, div, mul, mod, eql
    }

    struct Instruction {
        let op: Opcode
        let dest: String
        let src: String?

        init(_ string: String) {
            let tokens = string.split(separator: " ")
            op = Opcode(rawValue: String(tokens[0]))!
            dest = String(tokens[1])
            if tokens.count == 3 {
                src = String(tokens[2])
            } else {
                src = nil
            }
        }
    }

    class ALU: CustomStringConvertible {

        private(set) var registers = [ "w": 0 ]
        private var ic = 0

        init() {
            reset()
        }

        var description: String {
            ["w","x","y","z"].map {
                "\($0)=\(registers[$0]!)"
            }.joined(separator: " ")
        }

        var z: Int {
            get { registers["z"]! }
            set { registers["z"] = newValue }
        }

        func reset() {
            registers = [ "w": 0, "x": 0, "y": 0, "z": 0]
        }

        func run(_ program: [Instruction], _ input: [Int]) {
            ic = 0
            for instruction in program {
                switch instruction.op {
                case .inp:
                    registers[instruction.dest] = input[ic]
                    ic += 1
                case .add:
                    registers[instruction.dest]! += value(instruction.src)
                case .mul:
                    registers[instruction.dest]! *= value(instruction.src)
                case .div:
                    assert(value(instruction.src) != 0)
                    registers[instruction.dest]! /= value(instruction.src)
                case .mod:
                    assert(value(instruction.src) > 0)
                    assert(registers[instruction.dest]! >= 0)
                    registers[instruction.dest]! %= value(instruction.src)
                case .eql:
                    let eq = registers[instruction.dest]! == value(instruction.src)
                    registers[instruction.dest] = eq ? 1 : 0
                }
                // print(description)
            }
        }

        private func value(_ src: String?) -> Int {
            guard let src = src else {
                fatalError()
            }

            if let i = Int(src) {
                return i
            } else {
                return registers[src]!
            }
        }
    }

    let params = [
        [1,11,5],
        [1,13,5],
        [1,12,1],
        [1,15,15],
        [1,10,2],
        [26,-1,2],
        [1,14,5],
        [26,-8,8],
        [26,-7,14],
        [26,-8,12],
        [1,11,7],
        [26,-2,14],
        [26,-2,13],
        [26,-13,6]
    ]

    struct CacheKey: Hashable, Codable {
        let position: Int
        let input: Int
        let initialZ: Int
    }

    static func run() {
        // let data = testData
        let data = readFile(named: "puzzle24.txt")

        let program = Timer.time(day: 24) {
            data.map { Instruction($0) }
        }

        let puzzle = Puzzle24()

        puzzle.cacheTest()
//
//        print("Solution for part 1: \(puzzle.part1(program))")
//        print("Solution for part 2: \(puzzle.part2(data))")
    }

    private func part1(_ program: [Instruction]) -> Int {
        let timer = Timer(day: 24); defer { timer.show() }

        var cache = [CacheKey: Int]()

        var subroutines = [[Instruction]]()
        for i in stride(from: 0, to: program.count, by: 18) {
            let subroutine = Array(program[i..<i+18])
            subroutines.append(subroutine)
        }
        assert(subroutines.count == params.count)
//        let alu = ALU()

        var targetZ = Set([0])
        for (index, _) in subroutines.enumerated().reversed() {
//            print("-- digit \(index) ---")

            var nextTarget = Set<Int>()
            for initialZ in 0...1_000_000 {
                for input in 1...9 {
//                    alu.reset()
//                    alu.z = initialZ
//                    alu.run(sr, [input])
//                    let az = alu.z
                    let mz = monadOp(w: input, z: initialZ, params[index])
//                    assert(az == mz)
                    if targetZ.contains(mz) {
                        // print(index, input, initialZ)
                        nextTarget.insert(initialZ)
                        let key = CacheKey(position: index, input: input, initialZ: initialZ)
                        cache[key] = mz
                    }
                }
            }

            targetZ = nextTarget
            nextTarget.removeAll()
        }

        do {
            let data = try JSONEncoder().encode(cache)
            let url = URL(fileURLWithPath: "/tmp/day24.json")
            try data.write(to: url)
        } catch {
            print(error)
        }

        for index in 0..<subroutines.count {
            let keys = cache.keys.filter { $0.position == index }.count
            print("position", index, "count", keys)
        }

        if let max = findMax(cache, position: 0, initialZ: 0, value: 0) {
            print(max, isValid(max))
        }

        return 42
    }

    private func cacheTest() {
        let cache: [CacheKey: Int]
        do {
            let url = URL(fileURLWithPath: "/tmp/day24.json")
            let data = try Data(contentsOf: url)
            cache = try JSONDecoder().decode([CacheKey: Int].self, from: data)
        } catch {
            print(error)
            fatalError()
        }

//        print(cache.count)

//        for index in 0..<14 {
//            let keys = cache.keys.filter { $0.position == index }.count
//            print("position", index, "count", keys)
//        }

//        let k1 = cache.keys.filter { $0.position == 2 }
//        for k in k1 {
//            print(k, cache[k]!)
//        }

        for firstDigit in (1...9).reversed() {
            if let max = findMax(cache, position: 0, initialZ: 0, value: firstDigit) {
                print(max, isValid(max))
            }
        }
    }

    private func findMax(_ cache: [CacheKey: Int], position: Int, initialZ: Int, value: Int) -> Int? {
        print("findMax position=\(position)")
        print("testing", value, "z=\(zValue(value))")
        if position == 13 {
            return value
        }

        let keys = cache.keys
            .filter { $0.position == position + 1}
            .filter { $0.initialZ == initialZ }
            .sorted { $0.input > $1.input }
        print("keys found: \(keys.count) \(keys.map { $0.input })")
        for k in keys {
            let val = value * 10 + k.input
            let z = cache[k]!
            if let v = findMax(cache, position: position+1, initialZ: z, value: val) {
                return v
            }
        }
        // print("no match")
        return nil
    }

    private func isValid(_ number: Int) -> Bool {
        zValue(number) == 0
    }

    private func zValue(_ number: Int) -> Int {
        var z = 0
        for (index, n) in String(number).map({ Int(String($0))! }).enumerated() {
            z = monadOp(w: n, z: z, params[index])
        }
        return z
    }

    func monadOp(w: Int, z: Int, _ p: [Int]) -> Int {
        var z = z
        var x = (z % 26) + p[1]
        z /= p[0]
        x = (x != w) ? 1 : 0
        var y = (25 * x) + 1
        z *= y
        y = (w + p[2]) * x
        z += y
        return z
    }

    private func part2(_ data: [String]) -> Int {
        let timer = Timer(day: 24); defer { timer.show() }
        return 42
    }
}


/*
 input w
 x = 0
 x += z
 x %= 26
 z /= 1
 x += 11
 x = x==w ? 1 : 0
 x = x==0 ? 1 : 0
 y = 0
 y += 25
 y *= x
 y += 1
 z *= y
 y = 0
 y += w
 y += 5
 y *= x
 z += y

 input w
 x = (z % 26) + 11
 z /= 1
 x = (x==w) ? 1 : 0
 x = (x==0) ? 1 : 0
 y = (25 * x) + 1
 z *= y
 y = (w + 5) * x
 z += y
 */
