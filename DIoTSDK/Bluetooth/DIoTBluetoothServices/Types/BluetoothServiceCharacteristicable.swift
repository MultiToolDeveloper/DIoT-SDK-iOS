//
//  BluetoothServiceCharacteristicable.swift
//  DIoT_Demo_iOS
//
//  Created by Andrey Maslennikov on 07.04.2022.
//

import CoreBluetooth.CBUUID

/// Protocol
public protocol BluetoothServiceCharacteristicable {
    var rawValue: String { get }
}

extension BluetoothServiceCharacteristicable where Self: CaseIterable {
    /// Returns all characteristics UUIDs casted to CBUUID
    static var characteristics: [CBUUID] {
        return allCases.map { CBUUID(string: $0.rawValue) }
    }
}
