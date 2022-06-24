//
//  RemoteDeviceError.swift
//  DIoT_Demo_iOS
//
//  Created by Andrey Maslennikov on 07.04.2022.
//

public enum RemoteDeviceError {
    case connection(RemoteDeviceConnectionError)
    case state(RemoteDeviceStateError)
    case other(Error)
}

// MARK: Error
extension RemoteDeviceError: Error {}

// MARK: DIoTErrorProtocol
extension RemoteDeviceError: DIoTErrorProtocol {}

// MARK: Equatable
extension RemoteDeviceError: Equatable {
    public static func == (lhs: RemoteDeviceError, rhs: RemoteDeviceError) -> Bool {
        switch (lhs, rhs) {
        case let (.connection(left), .connection(right)): return left == right
        case let (.state(left), .state(right)): return left == right

        default: return false
        }
    }
}
