//
//  DeviceIdParser.swift
//  DIoT_Demo_iOS
//
//  Created by Andrey Maslennikov on 07.04.2022.
//

import Foundation

/// Position and length in hex string of information blocks (in bytes)
private typealias DeviceDataLocation = (position: Int, length: Int)

public final class DeviceIdParser {
    public init() {}
}

// MARK: DeviceIdParserProtocol
extension DeviceIdParser: DeviceIdParserProtocol {

    public func parseDeviceId(hexString: String) throws -> DeviceId {
        let string = filter(string: hexString)
        return try DeviceId(from: string)
    }

    public func parseHexString(fromDeviceId deviceId: DeviceId) -> String {
        return hexString(from: deviceId)
    }
}

// MARK: Private
private extension DeviceIdParser {
    /// Filters string from non alphanumeric characters.
    ///
    /// - Parameter hexString: string to be filtered
    /// - Returns: filtered string
    func filter(string: String) -> String {
        let string = string.replacingOccurrences(of: "0x", with: "")

        return string.components(separatedBy: CharacterSet.alphanumerics.inverted).joined()
    }

    func DeviceId(from string: String) throws -> DeviceId {
        // Multiply by 2 because Constants.manufactureSpecificLength is in bytes and in string.characters.count every 2 characters are 1 byte
        guard string.count == Constants.manufactureSpecificLength * 2 else { throw DeviceIdError.incorrectLength }
        let deviceUUID = try self.deviceUUID(fromHEX: string)
        return DIoTSDK.DeviceId(uuid: deviceUUID)
    }

    func hexString(from deviceId: DeviceId) -> String {
        let deviceIdHex = deviceUUIDHexString(from: deviceId.uuid)
        return "\(deviceIdHex)"
    }

}

// MARK: Private parsing logic
private extension DeviceIdParser {
    func deviceUUID(fromHEX string: String) throws -> UUID {
        var deviceUUIDString = try string.hexString(for: Constants.deviceUUID)
        deviceUUIDString.insert("-", at: deviceUUIDString.index(deviceUUIDString.startIndex, offsetBy: 8))
        deviceUUIDString.insert("-", at: deviceUUIDString.index(deviceUUIDString.startIndex, offsetBy: 13))
        deviceUUIDString.insert("-", at: deviceUUIDString.index(deviceUUIDString.startIndex, offsetBy: 18))
        deviceUUIDString.insert("-", at: deviceUUIDString.index(deviceUUIDString.startIndex, offsetBy: 23))
        guard let uuid = UUID(uuidString: deviceUUIDString) else {
            throw DeviceIdError.cannotBeParsed(.uuid)
        }
        return uuid
    }

    func deviceUUIDHexString(from deviceUUID: UUID) -> String {
        let data = withUnsafePointer(to: deviceUUID.uuid) {
                Data(bytes: $0, count: MemoryLayout.size(ofValue: deviceUUID.uuid))
        }
        return data.hexString.uppercased()
    }
}

// MARK: Constants
private extension DeviceIdParser {
    enum Constants {
        // advertisement id
        static let deviceUUID: DeviceDataLocation = (2, 16)                                          //(0,16)
        static let manufactureSpecificLength = 18 // Legth of correct string to be parsed (in bytes) //16
        static let deviceUUIDLength = 16 // Legth of correct string to be parsed (in bytes)
    }
}

// MARK: Substring convenient method
private extension String {
    /// Returns a substring of hex string for deviceDataLocation
    ///
    /// - Parameter deviceDataLocation: tuple of position and length in bytes
    /// - Returns: returns substring
    /// - Throws: if substring execution fails, then throws error (SubstringErrors)
    func hexString(for deviceDataLocation: DeviceDataLocation) throws -> String {
        // We need multiplying by 2 here, because position and length are in bytes and evety byte takes 2 symbols in string
        return try substring(from: deviceDataLocation.position * 2, length: deviceDataLocation.length * 2)
    }
}
