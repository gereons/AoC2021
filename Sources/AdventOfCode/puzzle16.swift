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
        "A0016C880162017C3686B18A3D4780"
    ]

    static func run() {
        // let data = testData
        let data = readFile(named: "puzzle16.txt")

        let bits = Timer.time(day: 16) { () -> Bits in
            Bits(decodeToBits(data[0]))
        }
        let puzzle = Puzzle16()

        let p = Packet.create(from: bits)

//        print(p)
        print(p.versionSum())

        print("Solution for part 1: \(puzzle.part1(data))")
        print("Solution for part 2: \(puzzle.part2(data))")
    }

    private func part1(_ data: [String]) -> Int {
        let timer = Timer(day: 16); defer { timer.show() }
        return 42
    }

    private func part2(_ data: [String]) -> Int {
        let timer = Timer(day: 16); defer { timer.show() }
        return 42
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
