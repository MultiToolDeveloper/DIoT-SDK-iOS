//
//  DIoTCommandInterfaceBluetoothServiceCharacteristics.swift
//  DIoT_Demo_iOS
//
//  Created by Andrey Maslennikov on 07.04.2022.
//

import Foundation

public enum DIoTCommandInterfaceBluetoothServiceCharacteristics: String {
    case commandFeatures = "C001"
    case commandChannels = "C002"
    case commandRate = "C003"
   }

// MARK: - CaseIterable
extension DIoTCommandInterfaceBluetoothServiceCharacteristics: CaseIterable {}

// MARK: - BluetoothServiceCharacteristicable
extension DIoTCommandInterfaceBluetoothServiceCharacteristics: BluetoothServiceCharacteristicable {}
