//
//  RemoteDeviceStateError.swift
//  DIoT_Demo_iOS
//
//  Created by Andrey Maslennikov on 07.04.2022.
//

public enum RemoteDeviceStateError {
    case notSupported
    case notAvailable
    case failedConnect(Error?)
    case disconnected
    case timedOut
}

// MARK: Error
extension RemoteDeviceStateError: Error {}

// MARK: DIoTErrorProtocol
extension RemoteDeviceStateError: DIoTErrorProtocol {}

// MARK: Equatable
extension RemoteDeviceStateError: Equatable {
    public static func == (lhs: RemoteDeviceStateError, rhs: RemoteDeviceStateError) -> Bool {
        switch (lhs, rhs) {
        case (.notSupported, .notSupported): return true
        case (.notAvailable, .notAvailable): return true
        case (.timedOut, .timedOut): return true
        case (.disconnected, .disconnected): return true

        default: return false
        }
    }
}
