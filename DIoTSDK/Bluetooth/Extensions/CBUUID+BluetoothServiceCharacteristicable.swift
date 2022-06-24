//
//  CBUUID+BluetoothServiceCharacteristicable.swift
//  DIoT_Demo_iOS
//
//  Created by Andrey Maslennikov on 07.04.2022.
//

import CoreBluetooth.CBUUID

extension CBUUID {
    static func == (_ lhs: CBUUID, _ rhs: String) -> Bool {
        return lhs == CBUUID(string: rhs)
    }

    static func == (_ lhs: String, _ rhs: CBUUID) -> Bool {
        return CBUUID(string: lhs) == rhs
    }
}

extension CBUUID {
    static func == (_ lhs: CBUUID, _ rhs: BluetoothServiceCharacteristicable) -> Bool {
        return lhs == CBUUID(string: rhs.rawValue)
    }

    static func == (_ lhs: BluetoothServiceCharacteristicable, _ rhs: CBUUID) -> Bool {
        return CBUUID(string: lhs.rawValue) == rhs
    }
}
