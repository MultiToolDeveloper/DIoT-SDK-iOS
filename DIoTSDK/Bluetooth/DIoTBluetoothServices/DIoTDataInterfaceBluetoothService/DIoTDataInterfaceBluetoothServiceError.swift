//
//  DIoTDataInterfaceBluetoothServiceError.swift
//  DIoT_Demo_iOS
//
//  Created by Andrey Maslennikov on 07.04.2022.
//

import Foundation

public enum DIoTDataInterfaceBluetoothServiceError {
    case cannotParse(BluetoothCharacteristicValueParserError)
}

// MARK: - Error
extension DIoTDataInterfaceBluetoothServiceError: Error {}

// MARK: - DIoTErrorProtocol
extension DIoTDataInterfaceBluetoothServiceError: DIoTErrorProtocol {}
