//
//  PeripheralDelegate.swift
//  DIoT_Demo_iOS
//
//  Created by Andrey Maslennikov on 07.04.2022.
//

import CoreBluetooth.CBService
import CoreBluetooth.CBCharacteristic

public protocol PeripheralDelegate: class, CBPeripheralDelegate {
    func peripheral(_ peripheral: PeripheralProtocol, didDiscoverServices error: Error?)
    func peripheral(_ peripheral: PeripheralProtocol, didDiscoverCharacteristicsFor service: CBService, error: Error?)
    func peripheral(_ peripheral: PeripheralProtocol, didUpdateValueFor characteristic: CBCharacteristic, error: Error?)
    func peripheral(_ peripheral: PeripheralProtocol, didUpdateNotificationStateFor characteristic: CBCharacteristic, error: Error?)
    func peripheral(_ peripheral: PeripheralProtocol, didWriteValueFor characteristic: CBCharacteristic, error: Error?)
    func peripheral(_ peripheral: PeripheralProtocol, didReadRSSI RSSI: NSNumber, error: Error?)
}
