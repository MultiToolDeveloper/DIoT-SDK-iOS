//
//  DIoTBluetoothConnectionError.swift
//  DIoT_Demo_iOS
//
//  Created by Andrey Maslennikov on 21.06.2022.
//

import Foundation
import CoreBluetooth.CBError

public enum DIoTBluetoothConnectionError: Equatable {
    case serviceUnavaliable(BluetoothServiceType)
    case cannotHandleService(String)
    case cannotHandleServiceFromCaracteristic(String)
    case connectionError
    case other(CBError)
}

// MARK: - Error
extension DIoTBluetoothConnectionError: Error {}

// MARK: - DIoTErrorProtocol
extension DIoTBluetoothConnectionError: DIoTErrorProtocol {}
