//
// Advent of Code 2021 Day 18
//

import AoCTools

final class Day18: AdventOfCodeDay {
    let title = "Snailfish"

    let nodes: [Node]

    init(input: String) {
        nodes = input.lines.map {
            Parser.createNode(from: $0)
        }
    }

    func part1() -> Int {
        var result = Node.add(nodes[0], nodes[1])
        result.reduce()
        for index in 2 ..< nodes.count {
            result = Node.add(result, nodes[index])
            result.reduce()
        }
        return result.magnitude()
    }

    func part2() -> Int {
        var maxMagnitude = 0
        for i in 0..<nodes.count {
            for j in 0..<nodes.count {
                if i == j { continue }
                let n = Node.add(nodes[i], nodes[j])
                n.reduce()
                maxMagnitude = max(maxMagnitude, n.magnitude())
            }
        }
        return maxMagnitude
    }
}

extension Day18 {
    final class Node: @unchecked Sendable {
        var value: Int
        var left: Node?
        var right: Node?

        init(value: Int) {
            self.value = value
        }

        init(left: Node, right: Node) {
            self.value = 0
            self.left = left
            self.right = right
        }

        // recursively copy the tree
        func copy() -> Node {
            if let left = left, let right = right {
                return Node(left: left.copy(), right: right.copy())
            }
            return Node(value: value)
        }

        static func add(_ n1: Node, _ n2: Node) -> Node {
            Node(left: n1.copy(), right: n2.copy())
        }

        func magnitude() -> Int {
            if let left = left, let right = right {
                return (3 * left.magnitude()) + (2 * right.magnitude())
            } else {
                return value
            }
        }

        private func addToLeftmost(_ add: Int?) {
            guard let add = add else { return }
            if let left = left {
                left.addToLeftmost(add)
            } else if let right = right {
                right.addToLeftmost(add)
            }
            value += add
        }

        private func addToRightmost(_ add: Int?) {
            guard let add = add else { return }
            if let right = right {
                right.addToRightmost(add)
            } else if let left = left {
                left.addToRightmost(add)
            }
            value += add
        }

        @discardableResult
        func explode(_ depth: Int = 0) -> (Int?, Int?)? {
            if depth >= 4 {
                if left == nil && right == nil {
                    return nil
                }
                let result = (left!.value, right!.value)
                self.value = 0
                self.left = nil
                self.right = nil
                return result
            }

            if let left = left, let right = right {
                if let (addLeft, addRight) = left.explode(depth + 1) {
                    right.addToLeftmost(addRight)
                    return (addLeft, nil)
                }
                if let (addLeft, addRight) = right.explode(depth + 1) {
                    left.addToRightmost(addLeft)
                    return (nil, addRight)
                }
            }
            return nil
        }

        @discardableResult
        func split() -> Bool {
            if let left = left, let right = right {
                if left.split() { return true }
                if right.split() { return true }
            } else {
                if value > 9 {
                    left = Node(value: value/2)
                    right = Node(value: value - value/2)
                    value = 0
                    return true
                }
            }

            return false
        }

        func reduce() {
            while true {
                if self.explode() != nil { continue }
                if self.split() { continue }
                break
            }
        }

        func dump(inner: Bool = false) {
            if let left = left, let right = right {
                print("[", terminator: "")
                left.dump(inner: true)
                print(",", terminator: "")
                right.dump(inner: true)
                print("]", terminator: inner ? "" : "\n" )
            } else {
                if left != nil || right != nil {
                    fatalError()
                }
                print(value, terminator: "")
            }
        }
    }

    enum TokenType {
        case obracket
        case cbracket
        case integer
        case comma
    }

    struct Token {
        let type: TokenType
        let value: Character
    }

    struct Tokenizer {
        static func tokenize(code: String) -> [Token] {
            var tokens = [Token]()
            for ch in code {
                switch ch {
                case "[": tokens.append(Token(type: .obracket, value: ch))
                case "]": tokens.append(Token(type: .cbracket, value: ch))
                case ",": tokens.append(Token(type: .comma, value: ch))
                case "0"..."9": tokens.append(Token(type: .integer, value: ch))
                default:
                    continue
                }
            }
            return tokens
        }
    }

    final class Parser {
        private var tokens: [Token]

        init(tokens: [Token]) {
            self.tokens = tokens
        }

        func parse() -> Node {
            return node()
        }

        static func createNode(from string: String) -> Node {
            let parser = Parser(tokens: Tokenizer.tokenize(code: string))
            return parser.parse()
        }

        private func node() -> Node {
            consume(.obracket)
            let lhs = intOrPair()
            consume(.comma)
            let rhs = intOrPair()
            consume(.cbracket)

            return Node(left: lhs, right: rhs)
        }

        private func intOrPair() -> Node {
            if peek(.integer) {
                var value = 0
                while peek(.integer) {
                    value *= 10
                    let i = Int(String(consume(.integer).value))!
                    value += i
                }
                return Node(value: value)
            } else {
                return node()
            }
        }

        private func peek(_ expected: TokenType) -> Bool {
            guard !tokens.isEmpty else { return false }
            return tokens[0].type == expected
        }

        @discardableResult
        private func consume(_ expected: TokenType) -> Token {
            if tokens[0].type == expected {
                return tokens.remove(at: 0)
            } else {
                fatalError("expected \(expected), got \(tokens[0].type)")
            }
        }
    }
}
