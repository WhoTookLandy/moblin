import CoreMedia
import Foundation

enum ElementaryStreamType: UInt8 {
    case unspecific = 0x00
    case mpeg1Video = 0x01
    case mpeg2Video = 0x02
    case mpeg1Audio = 0x03
    case mpeg2Audio = 0x04
    case mpeg2TabledData = 0x05
    case mpeg2PacketizedData = 0x06
    case adtsAac = 0x0F
    case h263 = 0x10
    case h264 = 0x1B
    case h265 = 0x24
}

struct ElementaryStreamSpecificData {
    static let fixedHeaderSize = 5
    var streamType: ElementaryStreamType = .unspecific
    var elementaryPacketId: UInt16 = 0
    var esInfoLength: UInt16 = 0
    var esDescriptors = Data()

    init() {}

    init(data: Data) throws {
        let reader = ByteReader(data: data)
        streamType = try ElementaryStreamType(rawValue: reader.readUInt8()) ?? .unspecific
        elementaryPacketId = try reader.readUInt16() & 0x0FFF
        esInfoLength = try reader.readUInt16() & 0x01FF
        esDescriptors = try reader.readBytes(Int(esInfoLength))
    }

    func encode() -> Data {
        let writer = ByteWriter()
        writer.writeUInt8(streamType.rawValue)
        writer.writeUInt16(elementaryPacketId | 0xE000)
        writer.writeUInt16(esInfoLength | 0xF000)
        writer.writeBytes(esDescriptors)
        return writer.data
    }
}
