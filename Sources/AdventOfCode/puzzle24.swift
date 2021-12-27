import Foundation

class Puzzle24 {
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

    struct Input {
        let divZ, addX, addY: Int

        init(_ divZ: Int, _ addX: Int, _ addY: Int) {
            self.divZ = divZ
            self.addX = addX
            self.addY = addY
        }
    }

    let inputs = [
        // divZ, addX, addY
        Input(1,   11,  5),
        Input(1,   13,  5),
        Input(1,   12,  1),
        Input(1,   15, 15),
        Input(1,   10,  2),
        Input(26,  -1,  2),
        Input(1,   14,  5),
        Input(26,  -8,  8),
        Input(26,  -7, 14),
        Input(26,  -8, 12),
        Input(1,   11,  7),
        Input(26,  -2, 14),
        Input(26,  -2, 13),
        Input(26, -13,  6)
    ]

    static func run() {
        // let data = testData
//        let data = readFile(named: "puzzle24.txt")
//
//        let program = Timer.time(day: 24) {
//            data.map { Instruction($0) }
//        }

        let puzzle = Puzzle24()

        let (min, max) = puzzle.part1and2()
        print("Solution for part 1: \(max)")
        print("Solution for part 2: \(min)")
    }

    struct Key: Hashable {
        let group, prevZ: Int
    }

    private var cache = [Key: [String]]()
    private var maxZ = [Int]()

    private func part1and2() -> (String, String) {
        let timer = Timer(day: 24); defer { timer.show() }

        for index in 0..<inputs.count {
            let max = inputs.dropFirst(index).map { $0.divZ }.reduce(1, *)
            maxZ.append(max)
        }

        let validNumbers = findValidNumbers(0, 0) ?? []

        let min = validNumbers.min()!
        let max = validNumbers.max()!
        return (min, max)
    }

    private func findValidNumbers(_ group: Int, _ prevZ: Int) -> [String]? {
        if let cached = cache[Key(group: group, prevZ: prevZ)] {
            return cached
        }

        if group >= 14 {
            if prevZ == 0 { return [""] }
            return nil
        }

        if prevZ > maxZ[group] {
            return nil
        }

        var result = [String]()

        let nextW = inputs[group].addX + prevZ % 26

        if 0 < nextW && nextW < 10 {
            let nextZ = monadOp(w: nextW, z: prevZ, inputs[group])
            if let nextStrings = findValidNumbers(group + 1, nextZ) {
                for n in nextStrings {
                    result.append("\(nextW)\(n)")
                }
            }
        } else {
            for i in 1...9 {
                let nextZ = monadOp(w: i, z: prevZ, inputs[group])
                if let nextStrings = findValidNumbers(group + 1, nextZ) {
                    for n in nextStrings {
                        result.append("\(i)\(n)")
                    }
                }
            }
        }

        cache[Key(group: group, prevZ: prevZ)] = result
        return result
    }

    func monadOp(w: Int, z: Int, _ input: Input) -> Int {
        var z = z
        var x = (z % 26) + input.addX
        z /= input.divZ
        x = (x != w) ? 1 : 0
        var y = (25 * x) + 1
        z *= y
        y = (w + input.addY) * x
        z += y
        return z
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
