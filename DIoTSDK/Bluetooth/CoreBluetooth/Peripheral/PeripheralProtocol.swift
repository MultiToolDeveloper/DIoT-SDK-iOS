//
//  PeripheralProtocol.swift
//  DIoT_Demo_iOS
//
//  Created by Andrey Maslennikov on 07.04.2022.
//

import CoreBluetooth

public protocol PeripheralProtocol: class {
    var delegate: PeripheralDelegate? { get set }
    
    var identifier: UUID { get }
    var name: String? { get }
    var state: CBPeripheralState { get }
    var services: [CBService]? { get }

    func readRSSI()
    func discoverServices(_ serviceUUIDs: [CBUUID]?)
    func discoverCharacteristics(_ characteristicUUIDs: [CBUUID]?, for service: CBService)
    func readValue(for characteristic: CBCharacteristic)
    func writeValue(_ data: Data, for characteristic: CBCharacteristic, type: CBCharacteristicWriteType)
    func setNotifyValue(_ enabled: Bool, for characteristic: CBCharacteristic)
}
