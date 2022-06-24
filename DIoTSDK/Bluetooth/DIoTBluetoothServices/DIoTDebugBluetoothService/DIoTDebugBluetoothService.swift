//
//  DIoTDebugBluetoothService.swift
//  DIoT_Demo_iOS
//
//  Created by Andrey Maslennikov on 07.04.2022.
//

import CoreBluetooth.CBCharacteristic

final class DIoTDebugBluetoothService: BluetoothService {
    
    private var subscribers = DIoTHashTable()

    override func handleDidUpdateValue(for bluetoothCharacteristic: CBCharacteristic) {
        guard let characteristic = DIoTDebugBluetoothServiceCharacteristics(rawValue: bluetoothCharacteristic.uuid.uuidString) else { return }

        handleUpdateValue(bluetoothCharacteristic.value, for: characteristic)
    }

    override func handleDidWriteValue(for characteristic: CBCharacteristic) {
        // Nothing to do here
    }

    override func handleDidUpdateNotificationState(for characteristic: CBCharacteristic) {
        guard let generalCharacteristic = DIoTDebugBluetoothServiceCharacteristics(rawValue: characteristic.uuid.uuidString) else { return }

        handleUpdateSubscription(characteristic, generalCharacteristic)
    }
}

// MARK: - DebugBluetoothServiceProtocol
extension DIoTDebugBluetoothService: DIoTDebugBluetoothServiceProtocol {
    func notifyDebug(enable: Bool) {
        setNotifyValue(enable, for: DIoTDebugBluetoothServiceCharacteristics.logs)
    }
    
    func sendDebug(command: String) {
        var value: [UInt8] = Array(command.utf8)
        var data = Data(bytes: &value, count: value.count)
        //make sure between .withResponse and .withoutResponse
        writeValue(data, for: DIoTDebugBluetoothServiceCharacteristics.logs, type: .withResponse)
    }
    
    func subscribe(subscriber: DIoTDebugBluetoothServiceDelegate) {
        if !subscribers.contains(subscriber) {
            subscribers.add(subscriber)
        }
    }
    
    func unsubscribe(subscriber: DIoTDebugBluetoothServiceDelegate) {
        if subscribers.contains(subscriber) {
            subscribers.remove(subscriber)
        }
    }
    
}

// MARK: - Handle update values
private extension DIoTDebugBluetoothService {
    func handleUpdateValue(_ data: Data?, for characteristic: DIoTDebugBluetoothServiceCharacteristics) {
        switch characteristic {
        case .logs: handleUpdateLogs(data)
        }
    }

    private func handleUpdateLogs(_ data: Data?) {
        guard let data = data else { return }

        let value = try! DebugParser.value(from: data)

        subscribers.forEach(as: DIoTDebugBluetoothServiceDelegate.self) {
            $0.debugService(self, didReceiveLogs: value)
        }
    }
}

// MARK: - Handle subscribe values
private extension DIoTDebugBluetoothService {
    func handleUpdateSubscription(_ bluetoothCharacteristic: CBCharacteristic, _ generalCharacteristic: DIoTDebugBluetoothServiceCharacteristics) {
        switch generalCharacteristic {
        case .logs: handleUpdateLogsSubscription(bluetoothCharacteristic)
        }
    }
    
    private func handleUpdateLogsSubscription(_ characteristic: CBCharacteristic) {
        subscribers.forEach(as: DIoTDebugBluetoothServiceDelegate.self) {
            $0.debugService(self, subscriptionStatusChange: characteristic.isNotifying)
        }
    }
}

