//
//  DIoTDebugBluetoothServiceCharacteristics.swift
//  DIoT_Demo_iOS
//
//  Created by Andrey Maslennikov on 07.04.2022.
//

public enum DIoTDebugBluetoothServiceCharacteristics: String {
    case logs = "FF71"
}

// MARK: CaseIterable
extension DIoTDebugBluetoothServiceCharacteristics: CaseIterable {}

// MARK: BluetoothServiceCharacteristicable
extension DIoTDebugBluetoothServiceCharacteristics: BluetoothServiceCharacteristicable {}
