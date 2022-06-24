//
//  GeneralDeviceInformationBluetoothService.swift
//  DIoT_Demo_iOS
//
//  Created by Andrey Maslennikov on 07.04.2022.
//

import CoreBluetooth.CBService

final class GeneralDeviceInformationBluetoothService: BluetoothService {

    private var subscribers = DIoTHashTable()

    override func handleDidUpdateValue(for bluetoothCharacteristic: CBCharacteristic) {
        guard let characteristic = GeneralDeviceInformationBluetoothServiceCharacteristics(rawValue: bluetoothCharacteristic.uuid.uuidString) else {
            return
        }

        handleUpdateValue(bluetoothCharacteristic.value, for: characteristic)
    }

    override func handleDidWriteValue(for bluetoothCharacteristic: CBCharacteristic) {
        // No need
    }

    override func handleDidUpdateNotificationState(for bluetoothCharacteristic: CBCharacteristic) {
        // No need
    }
}

// MARK: - GeneralDeviceInformationServiceProtocol
extension GeneralDeviceInformationBluetoothService: GeneralDeviceInformationBluetoothServiceProtocol {
    func subscribe(subscriber: GeneralDeviceInformationBluetoothServiceDelegate) {
        if !subscribers.contains(subscriber) {
            subscribers.add(subscriber)
        }
    }
    
    func unsubscribe(subscriber: GeneralDeviceInformationBluetoothServiceDelegate) {
        if subscribers.contains(subscriber) {
            subscribers.remove(subscriber)
        }
    }
    
    func fetchFirmwareVersion() {
        readValue(for: GeneralDeviceInformationBluetoothServiceCharacteristics.firmwareRevision)
    }

    func fetchSoftwareVersion() {
        readValue(for: GeneralDeviceInformationBluetoothServiceCharacteristics.softwareRevision)
    }

    func fetchHardwareVersion() {
        readValue(for: GeneralDeviceInformationBluetoothServiceCharacteristics.hardwareRevision)
    }

    func fetchManufactureName() {
        readValue(for: GeneralDeviceInformationBluetoothServiceCharacteristics.manufacturerName)
    }

    func fetchModelNumber() {
        readValue(for: GeneralDeviceInformationBluetoothServiceCharacteristics.modelNumber)
    }
}

// MARK: - Handle updating of characteristic
private extension GeneralDeviceInformationBluetoothService {
    func handleUpdateValue(_ data: Data?, for characteristic: GeneralDeviceInformationBluetoothServiceCharacteristics) {
        guard let data = data else { return }

        switch characteristic {
        case .firmwareRevision: handleUpdateFirmwareRevision(data)

        case .hardwareRevision: handleUpdateHardwareRevision(data)

        case .manufacturerName: handleUpdateManufactureName(data)

        case .modelNumber: handleUpdateModelNumber(data)

        case .softwareRevision: handleUpdateSoftwareRevision(data)
        }
    }

    private func handleUpdateFirmwareRevision(_ data: Data) {
        guard let firmwareRevision = data.stringValue() else { return }

        subscribers.forEach(as: GeneralDeviceInformationBluetoothServiceDelegate.self) {
            $0.deviceInformationService(self, didReceiveFirmwareRevision: firmwareRevision)
        }
    }

    private func handleUpdateHardwareRevision(_ data: Data) {
        guard let hardwareRevision = data.stringValue() else { return }
        
        subscribers.forEach(as: GeneralDeviceInformationBluetoothServiceDelegate.self) {
            $0.deviceInformationService(self, didReceiveHardwareRevision: hardwareRevision)
        }
    }

    private func handleUpdateManufactureName(_ data: Data) {
        guard let manufactureName = data.stringValue() else { return }
        
        subscribers.forEach(as: GeneralDeviceInformationBluetoothServiceDelegate.self) {
            $0.deviceInformationService(self, didReceiveManufactureName: manufactureName)
        }
    }

    private func handleUpdateModelNumber(_ data: Data) {
        guard let modelNumber = data.stringValue() else { return }
        
        subscribers.forEach(as: GeneralDeviceInformationBluetoothServiceDelegate.self) {
            $0.deviceInformationService(self, didReceiveModelNumber: modelNumber)
        }
    }

    private func handleUpdateSoftwareRevision(_ data: Data) {
        guard let softwareRevision = data.stringValue() else { return }
        
        subscribers.forEach(as: GeneralDeviceInformationBluetoothServiceDelegate.self) {
            $0.deviceInformationService(self, didReceiveSoftwareRevision: softwareRevision)
        }
    }
}
