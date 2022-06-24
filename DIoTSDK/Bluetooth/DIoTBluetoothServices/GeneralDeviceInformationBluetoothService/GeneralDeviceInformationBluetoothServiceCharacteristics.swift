//
//  GeneralDeviceInformationBluetoothServiceCharacteristics.swift
//  DIoT_Demo_iOS
//
//  Created by Andrey Maslennikov on 07.04.2022.
//

/// Characteristic UUIDs for **device information** service
///
/// - manufacturerName: manufacture name UUID
/// - modelNumber: model number UUID
/// - hardwareRevision: hardware revision UUID
/// - firmwareRevision: bootloader revision UUID
/// - softwareRevision: software revision UUID
public enum GeneralDeviceInformationBluetoothServiceCharacteristics: String {
    case manufacturerName = "2A29"
    case modelNumber = "2A24"
    case hardwareRevision = "2A27"
    case firmwareRevision = "2A26"
    case softwareRevision = "2A28"
}

// MARK: - CaseIterable
extension GeneralDeviceInformationBluetoothServiceCharacteristics: CaseIterable {}

// MARK: - BluetoothServiceCharacteristicable
extension GeneralDeviceInformationBluetoothServiceCharacteristics: BluetoothServiceCharacteristicable {}
