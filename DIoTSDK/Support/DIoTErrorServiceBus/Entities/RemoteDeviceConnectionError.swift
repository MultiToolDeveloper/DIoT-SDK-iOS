//
//  RemoteDeviceConnectionError.swift
//  DIoT_Demo_iOS
//
//  Created by Andrey Maslennikov on 07.04.2022.
//

public enum RemoteDeviceConnectionError {
    case ble(RemoteDeviceBleError)
    case iot
}

// MARK: Error
extension RemoteDeviceConnectionError: Error {}

// MARK: DIoTErrorProtocol
extension RemoteDeviceConnectionError: DIoTErrorProtocol {}

// MARK: Equatable
extension RemoteDeviceConnectionError: Equatable {
    public static func == (lhs: RemoteDeviceConnectionError, rhs: RemoteDeviceConnectionError) -> Bool {
        switch (lhs, rhs) {
        case let (.ble(left), .ble(right)): return left == right
        case (.iot, .iot): return true

        default: return false
        }
    }
}
