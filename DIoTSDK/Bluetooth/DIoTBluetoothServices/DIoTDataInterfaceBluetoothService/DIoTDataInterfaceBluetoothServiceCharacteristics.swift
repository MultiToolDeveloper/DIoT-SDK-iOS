//
//  DIoTDataInterfaceBluetoothServiceCharacteristics.swift
//  DIoT_Demo_iOS
//
//  Created by Andrey Maslennikov on 07.04.2022.
//

import Foundation

public enum DIoTDataInterfaceBluetoothServiceCharacteristics: String {
    case dataChannel1 = "D001"
    case dataChannel2 = "D002"
    case dataChannel3 = "D003"
    case dataChannel4 = "D004"
    case dataChannel5 = "D005"
    case dataChannel6 = "D006"
    case dataChannel7 = "D007"
    case dataChannel8 = "D008"
    case dataChannel9 = "D009"
   }

// MARK: - CaseIterable
extension DIoTDataInterfaceBluetoothServiceCharacteristics: CaseIterable {}

// MARK: - BluetoothServiceCharacteristicable
extension DIoTDataInterfaceBluetoothServiceCharacteristics: BluetoothServiceCharacteristicable {}
