//
//  DIoTDeviceIdBluetoothServiceError.swift
//  DIoT_Demo_iOS
//
//  Created by Andrey Maslennikov on 07.04.2022.
//


public enum DIoTDeviceIdBluetoothServiceError {
    case cannotParse(BluetoothCharacteristicValueParserError)
}

// MARK: - Error
extension DIoTDeviceIdBluetoothServiceError: Error {}

// MARK: - DIoTErrorProtocol
extension DIoTDeviceIdBluetoothServiceError: DIoTErrorProtocol {}
