//
// Advent of Code 2021 Day 16
//

import AoCTools

final class Day16: AdventOfCodeDay {
    let title = "Packet Decoder"

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
            return getPacket(from: bits)
        }

        private static func getPacket(from bits: Bits) -> Packet {
            let header = Header(version: bits.get(3), type: bits.get(3))
            if header.type == 4 {
                let content = Content.value(bits.readValue())
                return Packet(header: header, content: content)
            } else {
                let lengthType = bits.get(1)
                switch lengthType {
                case 0:
                    let bitLength = bits.get(15) // no. of bits for sub-packets
                    let subSet = bits.subSet(length: bitLength)
                    let subPackets = getPackets(from: subSet)
                    return Packet(header: header, content: .packets(subPackets))
                case 1:
                    let numberOfSubpackets = bits.get(11) // no. of sub-packets
                    var subPackets = [Packet]()
                    for _ in 0 ..< numberOfSubpackets {
                        subPackets.append(getPacket(from: bits))
                    }
                    return Packet(header: header, content: .packets(subPackets))
                default:
                    fatalError()
                }
            }
        }

        private static func getPackets(from bits: Bits) -> [Packet] {
            var result = [Packet]()
            while bits.packetAvailable {
                result.append(getPacket(from: bits))
            }
            return result
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

    final class Bits {
        let bits: [UInt8]

        private var index = 0

        init(_ bits: [UInt8]) {
            self.bits = bits
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

        func subSet(length: Int) -> Bits {
            let subBits = bits[index ..< index+length]
            index += length
            return Bits(Array(subBits))
        }

        // are there enough bits remaining for at least one packet?
        var packetAvailable: Bool {
            let minPacketSize = 3 + 3 + 5
            return index + minPacketSize <= bits.count
        }

        private func getRaw(_ n: Int) -> [UInt8] {
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
    }

    let packet: Packet

    init(input: String) {
        let bitmap: [Character: [UInt8]] = [
            "0": [0,0,0,0],
            "1": [0,0,0,1],
            "2": [0,0,1,0],
            "3": [0,0,1,1],
            "4": [0,1,0,0],
            "5": [0,1,0,1],
            "6": [0,1,1,0],
            "7": [0,1,1,1],
            "8": [1,0,0,0],
            "9": [1,0,0,1],
            "A": [1,0,1,0],
            "B": [1,0,1,1],
            "C": [1,1,0,0],
            "D": [1,1,0,1],
            "E": [1,1,1,0],
            "F": [1,1,1,1]
        ]

        let bits = Bits(input.flatMap { bitmap[$0]! })
        packet = Packet.create(from: bits)
    }

    func part1() -> Int {
        packet.versionSum()
    }

    func part2() -> Int {
        packet.eval()
    }
}
