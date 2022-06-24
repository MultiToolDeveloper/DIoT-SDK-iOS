//
//  RemoteDeviceBleError.swift
//  DIoT_Demo_iOS
//
//  Created by Andrey Maslennikov on 07.04.2022.
//

public enum RemoteDeviceBleError {
    case serviceNotFound
    case characteristicNotFound(String)
    case cannotSubscribeToCharacteristic(String)
    case invalidData
    case subscribersNotDefined
    case connectionError
    case failureWriteValue(Error?)
    case failureUpdateValue(Error?)
    case other(Error)
}

// MARK: Error
extension RemoteDeviceBleError: Error {
    public var localizedDescription: String {
        return "\(self)"
    }
}

// MARK: DIoTErrorProtocol
extension RemoteDeviceBleError: DIoTErrorProtocol {}

// MARK: Equatable
extension RemoteDeviceBleError: Equatable {
    public static func == (lhs: RemoteDeviceBleError, rhs: RemoteDeviceBleError) -> Bool {
        switch (lhs, rhs) {
        case (.serviceNotFound, .serviceNotFound): return true
        case let (.characteristicNotFound(left), .characteristicNotFound(right)): return left == right
        case let (.cannotSubscribeToCharacteristic(left), .cannotSubscribeToCharacteristic(right)): return left == right
        case (.invalidData, .invalidData): return true
        case (.subscribersNotDefined, .subscribersNotDefined): return true
        case (.connectionError, .connectionError): return true

        default: return false
        }
    }
}
