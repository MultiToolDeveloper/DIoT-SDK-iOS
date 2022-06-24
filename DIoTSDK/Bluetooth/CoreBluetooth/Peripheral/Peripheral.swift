//
//  Peripheral.swift
//  DIoT_Demo_iOS
//
//  Created by Andrey Maslennikov on 07.04.2022.
//

import CoreBluetooth.CBPeripheral

extension CBPeripheral {
    var proxy: PeripheralProtocol {
        return (delegate as? PeripheralProtocol) ?? Peripheral(object: self)
    }
}

final class Peripheral: NSObject {
    // Peripheral Protocol
    weak var delegate: PeripheralDelegate?

    // Private
    let object: CBPeripheral

    init(object: CBPeripheral) {
        self.object = object

        super.init()

        object.delegate = self
    }
}

// MARK: PeripheralProtocol
extension Peripheral: PeripheralProtocol {
    var identifier: UUID { return object.identifier }
    var name: String? { return object.name }
    var state: CBPeripheralState { return object.state }
    var services: [CBService]? { return object.services }

    func readRSSI() { object.readRSSI() }
    func discoverServices(_ serviceUUIDs: [CBUUID]?) { object.discoverServices(serviceUUIDs) }
    func readValue(for characteristic: CBCharacteristic) { object.readValue(for: characteristic) }

    func setNotifyValue(_ enabled: Bool, for characteristic: CBCharacteristic) {
        object.setNotifyValue(enabled, for: characteristic)
    }

    func discoverCharacteristics(_ characteristicUUIDs: [CBUUID]?, for service: CBService) {
        object.discoverCharacteristics(characteristicUUIDs, for: service)
    }

    func writeValue(_ data: Data, for characteristic: CBCharacteristic, type: CBCharacteristicWriteType) {
        object.writeValue(data, for: characteristic, type: type)
    }
}

// MARK: CBPeripheralDelegate
extension Peripheral: CBPeripheralDelegate {
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        delegate?.peripheral(peripheral.proxy, didDiscoverServices: error)
    }

    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        delegate?.peripheral(peripheral.proxy, didDiscoverCharacteristicsFor: service, error: error)
    }

    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        delegate?.peripheral(peripheral.proxy, didUpdateValueFor: characteristic, error: error)
    }

    func peripheral(_ peripheral: CBPeripheral, didUpdateNotificationStateFor characteristic: CBCharacteristic, error: Error?) {
        delegate?.peripheral(peripheral.proxy, didUpdateNotificationStateFor: characteristic, error: error)
    }

    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?) {
        delegate?.peripheral(peripheral.proxy, didWriteValueFor: characteristic, error: error)
    }

    func peripheral(_ peripheral: CBPeripheral, didReadRSSI RSSI: NSNumber, error: Error?) {
        delegate?.peripheral(peripheral.proxy, didReadRSSI: RSSI, error: error)
    }
}
