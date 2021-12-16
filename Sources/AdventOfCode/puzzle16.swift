import Foundation

private extension Array where Element == UInt8 {

}

struct Puzzle16 {
    struct Header {
        let version: Int
        let type: Int
    }

    enum Content {
        case value(Int)
        case packets([Packet])
    }

    struct Packet {
        let header: Header
        let content: Content

        static func create(from bits: Bits) -> Packet {
            let packets = getPackets(from: bits)
            assert(packets.count == 1)
            return packets[0]
        }

        private static func getPackets(from bits: Bits) -> [Packet] {
            var result = [Packet]()
            while bits.packetAvailable {
                result.append(getPacket(from: bits))
            }
            return result
        }

        private static func getPacket(from bits: Bits) -> Packet {
            let header = Header(version: bits.get(3), type: bits.get(3))
            if header.type == 4 {
                let content = Content.value(bits.readValue())
                let p = Packet(header: header, content: content)
                return p
            } else {
                let lengthType = bits.get(1)
                switch lengthType {
                case 0:
                    let bitLength = bits.get(15) // no. of bits for sub-packets
                    let subStream = bits.subStream(length: bitLength)
                    let subPackets = getPackets(from: subStream)
                    let p = Packet(header: header, content: .packets(subPackets))
                    return p
                case 1:
                    let numberOfSubpackets = bits.get(11) // no. of sub-packets
                    var subPackets = [Packet]()
                    for _ in 0 ..< numberOfSubpackets {
                        subPackets.append(getPacket(from: bits))
                    }
                    let p = Packet(header: header, content: .packets(subPackets))
                    return p
                default:
                    fatalError()
                }
            }
        }

        func versionSum() -> Int {
            switch self.content {
            case .value:
                return self.header.version
            case .packets(let packets):
                return self.header.version + packets.reduce(0) { sum, packet in
                    sum + packet.versionSum()
                }
            }
        }

        func eval() -> Int {
            switch self.content {
            case .value(let value):
                return value
            case .packets(let packets):
                switch self.header.type {
                case 0: // sum
                    return packets.reduce(0) { sum, p in
                        sum + p.eval()
                    }
                case 1: // product
                    return packets.reduce(1) { sum, p in
                        sum * p.eval()
                    }
                case 2: // min
                    var minP = Int.max
                    packets.forEach() {
                        minP = min(minP, $0.eval())
                    }
                    return minP
                case 3: // max
                    var maxP = 0
                    packets.forEach() {
                        maxP = max(maxP, $0.eval())
                    }
                    return maxP
                case 5: // greater
                    return packets[0].eval() > packets[1].eval() ? 1 : 0
                case 6: // less
                    return packets[0].eval() < packets[1].eval() ? 1 : 0
                case 7: // eq
                    return packets[0].eval() == packets[1].eval() ? 1 : 0
                default:
                    fatalError()
                }
            }
        }
    }

    class Bits {
        let bits: [UInt8]

        private var index = 0

        init(_ bits: [UInt8]) {
            self.bits = bits
        }

        func getRaw(_ n: Int) -> [UInt8] {
            let val = bits[index ..< index+n]
            index += n
            return Array(val)
        }

        private func intValue(_ bits: [UInt8]) -> Int {
            var value = 0
            bits.forEach {
                value <<= 1
                value |= Int($0)
            }
            return value
        }

        func get(_ n: Int) -> Int {
            intValue(getRaw(n))
        }

        // get 5-bit blocks until MSB is 0, return value of the concatenated remaining nibbles
        func readValue() -> Int {
            var value = 0
            var more = true
            while more {
                more = get(1) == 1
                value <<= 4
                value |= intValue(getRaw(4))
            }
            return value
        }

        func subStream(length: Int) -> Bits {
            let subBits = bits[index ..< index+length]
            index += length
            return Bits(Array(subBits))
        }

        var packetAvailable: Bool {
            let minPacketSize = 3 + 3 + 5
            return index + minPacketSize <= bits.count
        }
    }

    static let testData = [
        // "D2FE28"
        // "38006F45291200"
        // "EE00D40C823060"
        // "A0016C880162017C3686B18A3D4780"
        "9C0141080250320F1802104A08"
    ]

    static func run() {
        // let data = testData
        let data = readFile(named: "puzzle16.txt")

        let packet = Timer.time(day: 16) { () -> Packet in
            let bits = Bits(decodeToBits(data[0]))
            return Packet.create(from: bits)
        }
        let puzzle = Puzzle16()

        print("Solution for part 1: \(puzzle.part1(packet))")
        print("Solution for part 2: \(puzzle.part2(packet))")
    }

    private func part1(_ packet: Packet) -> Int {
        let timer = Timer(day: 16); defer { timer.show() }
        return packet.versionSum()
    }

    private func part2(_ packet: Packet) -> Int {
        let timer = Timer(day: 16); defer { timer.show() }
        return packet.eval()
    }

    private static func decodeToBits(_ str: String) -> [UInt8] {
        var bits = [UInt8]()
        for d in str.map({ $0 }) {
            switch d {
            case "0": bits.append(contentsOf: [0,0,0,0])
            case "1": bits.append(contentsOf: [0,0,0,1])
            case "2": bits.append(contentsOf: [0,0,1,0])
            case "3": bits.append(contentsOf: [0,0,1,1])
            case "4": bits.append(contentsOf: [0,1,0,0])
            case "5": bits.append(contentsOf: [0,1,0,1])
            case "6": bits.append(contentsOf: [0,1,1,0])
            case "7": bits.append(contentsOf: [0,1,1,1])
            case "8": bits.append(contentsOf: [1,0,0,0])
            case "9": bits.append(contentsOf: [1,0,0,1])
            case "A": bits.append(contentsOf: [1,0,1,0])
            case "B": bits.append(contentsOf: [1,0,1,1])
            case "C": bits.append(contentsOf: [1,1,0,0])
            case "D": bits.append(contentsOf: [1,1,0,1])
            case "E": bits.append(contentsOf: [1,1,1,0])
            case "F": bits.append(contentsOf: [1,1,1,1])
            default: fatalError()
            }
        }
        return bits
    }
}
