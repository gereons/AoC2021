//
// Advent of Code 2021 Day 24
//

import AoCTools

/*
 the ALU program consists of 14 blocks that all look like this:

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

 or, shorter:
 input w
 x = (z % 26) + 11
 z /= 1
 x = (x==w) ? 1 : 0
 x = (x==0) ? 1 : 0
 y = (25 * x) + 1
 z *= y
 y = (w + 5) * x
 z += y

 blocks only differ in 3 numeric parameters: addX, divZ and addY
 input w
 x = (z % 26) + addX
 z /= divZ
 x = (x==w) ? 1 : 0
 x = (x==0) ? 1 : 0
 y = (25 * x) + 1
 z *= y
 y = (w + addY) * x
 z += y
 */

final class Day24: AdventOfCodeDay {
    let title = "Arithmetic Logic Unit"

    struct Input {
        let divZ, addX, addY: Int

        init(_ lines: [String]) {
            assert(lines.count == 17)
            divZ = lines[3].integers().first!
            addX = lines[4].integers().first!
            addY = lines[14].integers().first!
        }
    }

    let inputs: [Input]

    init(input: String) {
        let lines = input.lines

        let groups = lines.grouped(by: { $0 == "inp w" }).dropFirst()

        inputs = groups.map { Input($0) }
    }

    func part1() -> String {
        part1and2().1
    }

    func part2() -> String {
        part1and2().0
    }

    struct Key: Hashable {
        let group, prevZ: Int
    }

    private var cache = [Key: [String]]()
    private var maxZ = [Int]()

    private func part1and2() -> (String, String) {
        for index in 0..<inputs.count {
            let max = inputs.dropFirst(index).map { $0.divZ }.reduce(1, *)
            maxZ.append(max)
        }

        let validNumbers = (findValidNumbers(0, 0) ?? []).sorted()
        return (validNumbers.first!, validNumbers.last!)
    }

    private func findValidNumbers(_ group: Int, _ prevZ: Int) -> [String]? {
        let key = Key(group: group, prevZ: prevZ)

        if let cached = cache[key] {
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

        cache[key] = result
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


extension Day24 {
    // literal implementation of the ALU, not used for performance reasons
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

    final class ALU: CustomStringConvertible {
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
}
