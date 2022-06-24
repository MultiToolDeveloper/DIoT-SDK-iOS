//
//  DIoTDeviceIdBluetoothServiceCharacteristics.swift
//  DIoT_Demo_iOS
//
//  Created by Andrey Maslennikov on 07.04.2022.
//

public enum DIoTDeviceIdBluetoothServiceCharacteristics: String {
    case chipIdentifier = "FFD1"
}

// MARK: - CaseIterable
extension DIoTDeviceIdBluetoothServiceCharacteristics: CaseIterable {}

// MARK: - BluetoothServiceCharacteristicable
extension DIoTDeviceIdBluetoothServiceCharacteristics: BluetoothServiceCharacteristicable {}
