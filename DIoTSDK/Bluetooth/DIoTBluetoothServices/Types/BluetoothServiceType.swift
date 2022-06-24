//
//  BluetoothServiceType.swift
//  DIoT_Demo_iOS
//
//  Created by Andrey Maslennikov on 07.04.2022.
//

import CoreBluetooth.CBUUID

/// Bluetooth service's UUIDs
///
/// - battery: battery service UUID
/// - main: main service UUID
public enum BluetoothServiceType: String {
    case deviceInformation = "180A"
    case battery = "180F"
    case command = "C000"
    case data = "D000"
    case deviceIdentifier = "FFD0"
    case debug = "FF70"
}

// MARK: CBUUID
extension BluetoothServiceType {
    var uuid: CBUUID {
        return CBUUID(string: self.rawValue)
    }

    /// Returns all characteristics for specified service
    var characteristics: [CBUUID]? {
        switch self {
        case .deviceInformation: return GeneralDeviceInformationBluetoothServiceCharacteristics.characteristics
        case .battery: return GeneralBatteryBluetoothServiceCharacteristics.characteristics
        case .command: return DIoTCommandInterfaceBluetoothServiceCharacteristics.characteristics
        case .data: return DIoTDataInterfaceBluetoothServiceCharacteristics.characteristics
        case .deviceIdentifier: return  DIoTDeviceIdBluetoothServiceCharacteristics.characteristics
        case .debug: return  DIoTDebugBluetoothServiceCharacteristics.characteristics
        }
    }

    /// Creates service handle object
    func service(
        with peripheral: PeripheralProtocol,
        characteristics: [CBCharacteristic],
        queue: DispatchQueue)
        -> BluetoothServiceProtocol
    {
        switch self {
        case .deviceInformation:
            return GeneralDeviceInformationBluetoothService(peripheral: peripheral, characteristics: characteristics, queue: queue)
        case .battery:
            return GeneralBatteryBluetoothService(peripheral: peripheral, characteristics: characteristics, queue: queue)
        case .command:
            return DIoTCommandInterfaceBluetoothService(peripheral: peripheral, characteristics: characteristics, queue: queue)
        case .data:
            return DIoTDataInterfaceBluetoothService(peripheral: peripheral, characteristics: characteristics, queue: queue)
        case .deviceIdentifier:
            return DIoTDeviceIdBluetoothService(peripheral: peripheral, characteristics: characteristics, queue: queue)
        case .debug:
            return DIoTDebugBluetoothService(peripheral: peripheral, characteristics: characteristics, queue: queue)
        }
    }
}

// MARK: Services
public extension BluetoothServiceType {
    static var services: [BluetoothServiceType] {
        return [.battery, .command, .data, .deviceInformation, .debug, .deviceIdentifier]
    }
}
