//
//  BluetoothDeviceError.swift
//  DIoT_Demo_iOS
//
//  Created by Andrey Maslennikov on 07.04.2022.
//

import CoreBluetooth.CBError

public enum GeneralBluetoothDeviceError: Equatable {
    case serviceUnavaliable(BluetoothServiceType)
    case cannotHandleService(String)
    case cannotHandleServiceFromCaracteristic(String)
    case connectionError
    case other(CBError)
}

// MARK: - Error
extension GeneralBluetoothDeviceError: Error {}

// MARK: - DIoTErrorProtocol
extension GeneralBluetoothDeviceError: DIoTErrorProtocol {}
