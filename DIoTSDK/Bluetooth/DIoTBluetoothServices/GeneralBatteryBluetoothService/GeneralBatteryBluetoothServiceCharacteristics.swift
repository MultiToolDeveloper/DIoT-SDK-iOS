//
//  GeneralBatteryBluetoothServiceCharacteristics.swift
//  DIoT_Demo_iOS
//
//  Created by Andrey Maslennikov on 07.04.2022.
//

/// Characteristic UUIDs for specified service
///
/// - level: level variable UUID
public enum GeneralBatteryBluetoothServiceCharacteristics: String {
    case level = "2A19"
}

// MARK: CaseIterable
extension GeneralBatteryBluetoothServiceCharacteristics: CaseIterable {}

// MARK: BluetoothServiceCharacteristicable
extension GeneralBatteryBluetoothServiceCharacteristics: BluetoothServiceCharacteristicable {}
