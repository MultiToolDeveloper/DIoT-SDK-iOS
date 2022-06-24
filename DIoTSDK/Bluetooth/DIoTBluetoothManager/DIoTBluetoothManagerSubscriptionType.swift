//
//  BluetoothManagerSubscriptionType.swift
//  DIoT_Demo_iOS
//
//  Created by Andrey Maslennikov on 07.04.2022.
//

public enum DIoTBluetoothManagerSubscriptionType {
    case state
    case scan
    case connection
}

// MARK: - CaseIterable
extension DIoTBluetoothManagerSubscriptionType: CaseIterable {}
