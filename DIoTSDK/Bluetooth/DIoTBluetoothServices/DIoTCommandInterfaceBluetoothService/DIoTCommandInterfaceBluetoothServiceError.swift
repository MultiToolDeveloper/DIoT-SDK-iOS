//
//  DIoTCommandInterfaceBluetoothServiceError.swift
//  DIoT_Demo_iOS
//
//  Created by Andrey Maslennikov on 07.04.2022.
//

import Foundation

public enum DIoTCommandInterfaceBluetoothServiceError {
    case cannotParse(BluetoothCharacteristicValueParserError)
}

// MARK: - Error
extension DIoTCommandInterfaceBluetoothServiceError: Error {}

// MARK: - DIoTErrorProtocol
extension DIoTCommandInterfaceBluetoothServiceError: DIoTErrorProtocol {}
