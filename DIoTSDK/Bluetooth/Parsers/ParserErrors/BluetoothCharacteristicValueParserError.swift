//
//  BluetoothCharacteristicValueParserError.swift
//  DIoT_Demo_iOS
//
//  Created by Andrey Maslennikov on 07.04.2022.
//

public enum BluetoothCharacteristicValueParserError {
    case empty
    case cannotParse(BluetoothCharacteristicParserType)
}

// MARK: - Error
extension BluetoothCharacteristicValueParserError: Error {}

// MARK: - DIoTErrorProtocol
extension BluetoothCharacteristicValueParserError: DIoTErrorProtocol {}
