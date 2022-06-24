//
//  DIoTDeviceIdBluetoothService.swift
//  DIoT_Demo_iOS
//
//  Created by Andrey Maslennikov on 07.04.2022.
//

import CoreBluetooth.CBService

final class DIoTDeviceIdBluetoothService: BluetoothService {

    private var subscribers = DIoTHashTable()

    override func handleDidUpdateValue(for bluetoothCharacteristic: CBCharacteristic) {
        guard let characteristic = DIoTDeviceIdBluetoothServiceCharacteristics(rawValue: bluetoothCharacteristic.uuid.uuidString) else { return }

        handleUpdateValue(bluetoothCharacteristic.value, for: characteristic)
    }

    override func handleDidWriteValue(for bluetoothCharacteristic: CBCharacteristic) {
        guard let characteristic = DIoTDeviceIdBluetoothServiceCharacteristics(rawValue: bluetoothCharacteristic.uuid.uuidString) else { return }

        handleDidWriteValue(for: characteristic)
    }

    override func handleDidUpdateNotificationState(for bluetoothCharacteristic: CBCharacteristic) {
        guard let characteristic = DIoTDeviceIdBluetoothServiceCharacteristics(rawValue: bluetoothCharacteristic.uuid.uuidString) else { return }

        handleUpdateNotificationState(for: characteristic)
    }
}

// MARK: - BandMainBluetoothServiceProtocol
extension DIoTDeviceIdBluetoothService: DIoTDeviceIdBluetoothServiceProtocol {
    
    func subscribe(subscriber: DIoTDeviceIdBluetoothServiceDelegate) {
        if !subscribers.contains(subscriber) {
            subscribers.add(subscriber)
        }
    }
    
    func unsubscribe(subscriber: DIoTDeviceIdBluetoothServiceDelegate) {
        if subscribers.contains(subscriber) {
            subscribers.remove(subscriber)
        }
    }
    
    func fetchChipIdentier() {
        readValue(for: DIoTDeviceIdBluetoothServiceCharacteristics.chipIdentifier)
    }
}

// MARK: - Handle update values
private extension DIoTDeviceIdBluetoothService {
    func handleUpdateValue(_ value: Data?, for characteristic: DIoTDeviceIdBluetoothServiceCharacteristics) {
        guard let data = value else { return }

        switch characteristic {
        case .chipIdentifier: handleUpdateChipIdentifierValue(data)
        }
    }

    private func handleUpdateChipIdentifierValue(_ data: Data) {
        let value: String = data.hexString

        subscribers.forEach(as: DIoTDeviceIdBluetoothServiceDelegate.self) {
            $0.deviceIdService(self, didReceiveChipIdentifier: value)
        }
    }
}

// MARK: - Handle write values
private extension DIoTDeviceIdBluetoothService {
    func handleDidWriteValue(for characteristic: DIoTDeviceIdBluetoothServiceCharacteristics) {
        // No need
    }
}

// MARK: - Handle notification state changes
private extension DIoTDeviceIdBluetoothService {
    func handleUpdateNotificationState(for characteristic: DIoTDeviceIdBluetoothServiceCharacteristics) {
        // No need
    }
}

// MARK: - Handle errors
private extension DIoTDeviceIdBluetoothService {
    func handle(error: Error) {
        if let parseError = error as? BluetoothCharacteristicValueParserError {
            handle(parseError: parseError)
        }
    }

    private func handle(parseError: BluetoothCharacteristicValueParserError) {
        subscribers.forEach(as: DIoTDeviceIdBluetoothServiceDelegate.self) {
            $0.deviceIdService(self, didReceiveError: .cannotParse(parseError))
        }
    }
}
