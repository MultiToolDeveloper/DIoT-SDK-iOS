//
//  BluetoothService.swift
//  DIoT_Demo_iOS
//
//  Created by Andrey Maslennikov on 07.04.2022.
//

import CoreBluetooth.CBService

class BluetoothService {
    let queue: DispatchQueue
    let peripheral: PeripheralProtocol
    let characteristics: [CBCharacteristic]

    init(peripheral: PeripheralProtocol, characteristics: [CBCharacteristic], queue: DispatchQueue) {
        self.peripheral = peripheral
        self.queue = queue
        self.characteristics = characteristics
    }

    func handleDidUpdateValue(for characteristic: CBCharacteristic) {}

    func handleDidWriteValue(for characteristic: CBCharacteristic) {}

    func handleDidUpdateNotificationState(for characteristic: CBCharacteristic) {}
}

// MARK: - BluetoothServiceProtocol
extension BluetoothService: BluetoothServiceProtocol {
    func readValue(for characteristic: BluetoothServiceCharacteristicable) {
        queue.async {
            guard let bluetoothCharacteristic = self.coreBluetoothCharacteristic(for: characteristic) else {
                return
            }

            guard bluetoothCharacteristic.properties.contains(.read) else { return }

            self.peripheral.readValue(for: bluetoothCharacteristic)
        }
    }

    func writeValue(
        _ data: Data,
        for characteristic: BluetoothServiceCharacteristicable)
    {
        writeValue(data, for: characteristic, type: .withResponse)
    }

    func writeValue(
        _ data: Data,
        for characteristic: BluetoothServiceCharacteristicable,
        type: CBCharacteristicWriteType)
    {
        queue.async {
            guard let bluetoothCharacteristic = self.coreBluetoothCharacteristic(for: characteristic) else { return }

            guard bluetoothCharacteristic.properties.contains(type == .withResponse ? .write : .writeWithoutResponse) else { return }

            self.peripheral.writeValue(data, for: bluetoothCharacteristic, type: type)
        }
    }

    func setNotifyValue(_ enabled: Bool, for characteristic: BluetoothServiceCharacteristicable) {
        queue.async {
            guard let bluetoothCharacteristic = self.coreBluetoothCharacteristic(for: characteristic) else { return }

            guard bluetoothCharacteristic.properties.contains(.notify) else { return }

            self.peripheral.setNotifyValue(enabled, for: bluetoothCharacteristic)
        }
    }
}

// MARK: - Private
private extension BluetoothService {
    func coreBluetoothCharacteristic(for characteristic: BluetoothServiceCharacteristicable) -> CBCharacteristic? {
        return characteristics.first(where: { $0.uuid == characteristic })
    }
}
