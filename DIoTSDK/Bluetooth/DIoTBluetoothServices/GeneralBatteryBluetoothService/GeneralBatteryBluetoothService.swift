//
//  GeneralBatteryBluetoothService.swift
//  DIoT_Demo_iOS
//
//  Created by Andrey Maslennikov on 07.04.2022.
//

import CoreBluetooth.CBService

/// Service which should incapsulate work with CBService to retrieve battery level
final class GeneralBatteryBluetoothService: BluetoothService {

    private var subscribers = DIoTHashTable()
    
    override func handleDidUpdateValue(for bluetoothCharacteristic: CBCharacteristic) {
        guard let characteristic = GeneralBatteryBluetoothServiceCharacteristics(rawValue: bluetoothCharacteristic.uuid.uuidString) else { return }

        handleUpdateValue(bluetoothCharacteristic.value, for: characteristic)
    }

    override func handleDidWriteValue(for bluetoothCharacteristic: CBCharacteristic) {
        // No need
    }

    override func handleDidUpdateNotificationState(for bluetoothCharacteristic: CBCharacteristic) {
        guard let characteristic = GeneralBatteryBluetoothServiceCharacteristics(rawValue: bluetoothCharacteristic.uuid.uuidString) else { return }
        
        handleUpdateSubscription(bluetoothCharacteristic, characteristic)
    }
}

// MARK: - BatteryServiceProtocol
extension GeneralBatteryBluetoothService: GeneralBatteryBluetoothServiceProtocol {
    func subscribe(subscriber: GeneralBatteryBluetoothServiceDelegate) {
        if !subscribers.contains(subscriber) {
            subscribers.add(subscriber)
        }
    }
    
    func unsubscribe(subscriber: GeneralBatteryBluetoothServiceDelegate) {
        if subscribers.contains(subscriber) {
            subscribers.remove(subscriber)
        }
    }
    
    func notifyBatteryLevel(enable: Bool) {
        setNotifyValue(enable, for: GeneralBatteryBluetoothServiceCharacteristics.level)
    }
    
    func fetchBatteryLevel() {
        readValue(for: GeneralBatteryBluetoothServiceCharacteristics.level)
    }
    
}

// MARK: - Handle update values
private extension GeneralBatteryBluetoothService {
    func handleUpdateValue(_ value: Data?, for characteristic: GeneralBatteryBluetoothServiceCharacteristics) {
        switch characteristic {
        case .level: handleUpdateLevel(value)
        }
    }

    private func handleUpdateLevel(_ data: Data?) {
        guard let data = data else { return }

        let batteryLevel = BatteryParser.value(from: data)

        subscribers.forEach(as: GeneralBatteryBluetoothServiceDelegate.self) {
            $0.batteryService(self, didReceiveLevel: batteryLevel)
        }
    }
}

// MARK: - Handle subscribe values
private extension GeneralBatteryBluetoothService {
    func handleUpdateSubscription(_ bluetoothCharacteristic: CBCharacteristic, _ generalCharacteristic: GeneralBatteryBluetoothServiceCharacteristics) {
        switch generalCharacteristic {
            case .level: handleUpdateLevelSubscription(bluetoothCharacteristic)
        }
    }
    
    private func handleUpdateLevelSubscription(_ characteristic: CBCharacteristic) {
        subscribers.forEach(as: GeneralBatteryBluetoothServiceDelegate.self) {
            $0.batteryService(self, subscriptionStatusChange: characteristic.isNotifying)
        }
    }
    
}
