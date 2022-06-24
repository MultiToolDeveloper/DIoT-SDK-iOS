//
//  DebugParser.swift
//  DIoT_Demo_iOS
//
//  Created by Andrey Maslennikov on 07.04.2022.
//

import Foundation

public typealias DebugLogPart = String

final class DebugParser {
    static func value(from data: Data) throws -> DebugLogPart {
        guard let value = String(bytes: data, encoding: .ascii) else {
            throw BluetoothCharacteristicValueParserError.cannotParse(.debug)
        }

        return value
    }

    static func data(from value: DebugLogPart) throws -> Data {
        guard let data = value.data(using: .ascii) else {
            throw BluetoothCharacteristicValueParserError.cannotParse(.debug)
        }

        return data
    }
}
