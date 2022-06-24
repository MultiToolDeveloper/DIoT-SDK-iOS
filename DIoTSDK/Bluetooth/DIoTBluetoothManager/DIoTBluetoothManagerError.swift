//
//
//  BluetoothManagerScanningError.swift
//  DIoT_Demo_iOS
//
//  Created by Andrey Maslennikov on 07.04.2022.
//

// MARK: - BluetoothManagerScanningError
public enum DIoTBluetoothManagerScanningError {
    case cannotParseAdvertisementId(DeviceIdError)
}

// MARK: Error
extension DIoTBluetoothManagerScanningError: Error {}

// MARK: NeeboErrorProtocol
extension DIoTBluetoothManagerScanningError: DIoTErrorProtocol {}

// MARK: -

// MARK: BluetoothManagerError
public enum DIoTBluetoothManagerError {
    case centralManagerIsNotAvailable
}

// MARK: Error
extension DIoTBluetoothManagerError: Error {}

// MARK: DIoTErrorProtocol
extension DIoTBluetoothManagerError: DIoTErrorProtocol {}
