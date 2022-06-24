//
//  BatteryParser.swift
//  DIoT_Demo_iOS
//
//  Created by Andrey Maslennikov on 07.04.2022.
//

import Foundation

public final class BatteryParser {
    public static func value(from data: Data) -> UInt {
        let level: UInt8 = data.numberValue() ?? 0

        return UInt(level)
    }

    public static func data(from value: UInt?) -> Data {
        guard let value = value else { return Data(count: Constants.length) }

        var batteryValue = value

        return Data(bytes: &batteryValue, count: MemoryLayout<UInt8>.size)
    }

    private init() {}
}

// MARK: Constants
private extension BatteryParser {
    enum Constants {
        static let length = 1
    }
}
