//
//  DeviceParserProtocol.swift
//  DIoT_Demo_iOS
//
//  Created by Andrey Maslennikov on 07.04.2022.
//

public protocol DeviceIdParserProtocol {
    /// Try to parse hexString struct to DeviceId struct. Throwable
    ///
    /// - Parameter hexString: hex string
    /// - Returns: DeviceId value
    /// - Throws: if parsing fails throw an DeviceError
    func parseDeviceId(hexString: String) throws -> DeviceId

    /// Try to parse DeviceID struct back to hex string from which it was created
    ///
    /// - Parameter deviceId: DeviceID struct
    /// - Returns: original hex string
    func parseHexString(fromDeviceId deviceId: DeviceId) -> String
}
