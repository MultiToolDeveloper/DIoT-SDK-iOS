//
//  BluetoothDevice.swift
//  DIoT_Demo_iOS
//
//  Created by Andrey Maslennikov on 07.04.2022.
//
// Main class for all bluetooth devices. Incapsulates all main logic for working with BLE
// - connect
// - disconnect
// - fetchingRSSI
// - etc
//
// Also handles peripheral so that it won't be deleted by the system.

import CoreBluetooth

public class GeneralBluetoothDevice: NSObject {
    private let queue: DispatchQueue
    private(set) public var services: [BluetoothServiceType: BluetoothServiceProtocol] = [:]
    private var discoveredServices: [CBUUID] = []

    public var peripheral: PeripheralProtocol
    public let deviceId: DeviceId
    public let deviceName: String

    public var logger: LoggerServiceProtocol?
    public weak var delegate: GeneralBluetoothDeviceDelegate?
    public weak var manager: (DIoTBluetoothScanningManagerProtocol & DIoTBluetoothConnectionManagerProtocol)?

    public init(peripheral: PeripheralProtocol, deviceId: DeviceId, deviceName: String, queue: DispatchQueue) {
        self.peripheral = peripheral
        self.deviceId = deviceId
        self.deviceName = deviceName
        self.queue = queue

        super.init()

        self.peripheral.delegate = self
    }
}

// MARK: - DeviceProtocol
extension GeneralBluetoothDevice: GeneralBluetoothDeviceProtocol {
    public func connect() {
        logger?.info("[DeviceService] start connection to \(String(describing: peripheral.name)) with identifier \(peripheral.identifier)")

        manager?.subscribe(self, to: .connection)
        manager?.connect(to: peripheral)
    }

    public func disconnect() {
        logger?.info("[DeviceService] disconnect from \(String(describing: peripheral.name)) with identifier \(peripheral.identifier)")

        manager?.disconnect(from: peripheral)
    }

    public func fetchRSSI() {
        queue.async {
            self.peripheral.readRSSI()
        }
    }
}

// MARK: - PeripheralDelegate
extension GeneralBluetoothDevice: PeripheralDelegate {
    public func peripheral(_ peripheral: PeripheralProtocol, didDiscoverServices error: Error?) {
        guard error == nil else {
            logger?.info("[DeviceService] discovering services failed for peripheral \(peripheral.name ?? "") with identifier \(peripheral.identifier) with error \(error!)")

            handle(error: error!)

            return
        }

        logger?.info("[DeviceService] discovered services \(String(describing: peripheral.services))")

        discoveredServices.removeAll()

        guard let services = peripheral.services else {
            // There are no services to discovere but we have connected to this device so we notify our delegate
            delegate?.bluetoothDeviceDidConnect(self)

            return
        }

        discoveredServices = services.map({ $0.uuid })

        services.forEach { service in
            logger?.info("[DeviceService] discovered service \(service)) for peripheral \(peripheral.name ?? "") with identifier \(peripheral.identifier)")

            if let recognisedServiceType = BluetoothServiceType(rawValue: service.uuid.uuidString) {
                peripheral.discoverCharacteristics(recognisedServiceType.characteristics, for: service)
            } else {
                //remove service if it unrecognized
                discoveredServices = discoveredServices.filter { $0 != service.uuid }
            }
        }
    }

    public func peripheral(_ peripheral: PeripheralProtocol, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        guard error == nil else {
            handle(error: error!)

            return
        }

        if let index = discoveredServices.firstIndex(where: { $0 == service.uuid }) {
            discoveredServices.remove(at: index)
        }

        guard let characteristics = service.characteristics else {
            delegate?.bluetoothDeviceDidConnect(self)

            return
        }

        guard let serviceType = BluetoothServiceType(rawValue: service.uuid.uuidString) else {
            delegate?.bluetoothDeviceDidConnect(self)

            return
        }

        let bluetoothService = serviceType.service(with: peripheral, characteristics: characteristics, queue: queue)

        services[serviceType] = bluetoothService

        if discoveredServices.isEmpty {
            delegate?.bluetoothDeviceDidConnect(self)
        }
    }

    public func peripheral(_ peripheral: PeripheralProtocol, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        guard error == nil else {
            logger?.info("[DeviceService] updating value \(characteristic.valueHexString ?? "no data") failed with \(error!) for characteristic \(characteristic.uuid) for peripheral \(peripheral.name ?? "") with identifier \(peripheral.identifier)")

            handle(error: error!)

            return
        }

        logger?.info("[DeviceService] did update value \(characteristic.valueHexString ?? "no data") for characteristic \(characteristic.uuid) for peripheral \(peripheral.name ?? "") with identifier \(peripheral.identifier)")

        do {
            let bluetoothService = try service(for: characteristic)

            bluetoothService.handleDidUpdateValue(for: characteristic)
        } catch {
            handle(error: error)
        }
    }

    public func peripheral(_ peripheral: PeripheralProtocol, didUpdateNotificationStateFor characteristic: CBCharacteristic, error: Error?) {
        guard error == nil else {
            logger?.info("[DeviceService] updating notification state failed with \(error!) for characteristic \(characteristic.uuid) for peripheral \(peripheral.name ?? "") with identifier \(peripheral.identifier)")

            handle(error: error!)

            return
        }

        logger?.info("[DeviceService] did update notification state for characteristic \(characteristic.uuid) for peripheral \(peripheral.name ?? "") with identifier \(peripheral.identifier)")

        do {
            let bluetoothService = try service(for: characteristic)

            bluetoothService.handleDidUpdateNotificationState(for: characteristic)
        } catch {
            handle(error: error)
        }
    }

    public func peripheral(_ peripheral: PeripheralProtocol, didWriteValueFor characteristic: CBCharacteristic, error: Error?) {
        guard error == nil else {
            logger?.info("[DeviceService] writing value \(characteristic.valueHexString ?? "no data") failed for \(error!) for characteristic \(characteristic.uuid) for peripheral \(peripheral.name ?? "") with identifier \(peripheral.identifier)")

            handle(error: error!)

            return
        }

        logger?.info("[DeviceService] did write value \(characteristic.valueHexString ?? "no data") for characteristic \(characteristic.uuid) for peripheral \(peripheral.name ?? "") with identifier \(peripheral.identifier)")

        do {
            let bluetoothService = try service(for: characteristic)

            bluetoothService.handleDidWriteValue(for: characteristic)
        } catch {
            handle(error: error)
        }
    }

    public func peripheral(_ peripheral: PeripheralProtocol, didReadRSSI RSSI: NSNumber, error: Error?) {
        guard error == nil else {
            logger?.info("[DeviceService] reading rssi failed with \(error!) for peripheral \(peripheral.name ?? "") with identifier \(peripheral.identifier)")

            handle(error: error!)

            return
        }

        logger?.info("[DeviceService] did read rssi \(RSSI) for peripheral \(peripheral.name ?? "") with identifier \(peripheral.identifier)")

        delegate?.bluetoothDevice(self, didReceiveRSSI: RSSI.doubleValue)
    }
}

// MARK: - BluetoothManagerDelegate
extension GeneralBluetoothDevice: DIoTBluetoothConnectionManagerDelegate {
    public func bluetoothManager(_ service: DIoTBluetoothConnectionManagerProtocol, didConnectTo peripheral: PeripheralProtocol) {
        logger?.info("[DeviceService] did connect to peripheral \(peripheral.name ?? "") with identifier \(peripheral.identifier)")

        self.peripheral = peripheral
        self.peripheral.delegate = self

        let services = self.services.keys.map { $0.uuid }

        logger?.info("[DeviceService] start discovering of services \(String(describing: services))")

        peripheral.discoverServices(services)
    }

    public func bluetoothManager(_ service: DIoTBluetoothConnectionManagerProtocol, didFailToConnect peripheral: PeripheralProtocol) {
        logger?.info("[DeviceService] did fail to connect to peripheral \(peripheral.name ?? "") with identifier \(peripheral.identifier)")

        delegate?.bluetoothDeviceDidDisconnect(self)
        
        manager?.unsubscribe(self, from: .connection)
    }

    public func bluetoothManager(_ service: DIoTBluetoothConnectionManagerProtocol, didDisconnectFrom peripheral: PeripheralProtocol) {
        logger?.info("[DeviceService] disconnected from peripheral \(peripheral.name ?? "") with identifier \(peripheral.identifier)")

        delegate?.bluetoothDeviceDidDisconnect(self)
        
        manager?.unsubscribe(self, from: .connection)
    }
}

// MARK: - Handle errors
private extension GeneralBluetoothDevice {
    func handle(error: Error) {
        if let error = error as? CBError {
            handleCoreBluetoothError(error)
        }
    }

    private func handleCoreBluetoothError(_ error: CBError) {
        switch error.code {
        case .connectionFailed,
             .connectionTimeout,
             .notConnected,
             .peripheralDisconnected,
             .unknown:
            delegate?.bluetoothDevice(self, didReceiveError: .connectionError)

        case .alreadyAdvertising,
             .connectionLimitReached,
             .invalidHandle,
             .invalidParameters,
             .operationCancelled,
             .operationNotSupported,
             .outOfSpace,
             .unkownDevice,
             .uuidNotAllowed:
            delegate?.bluetoothDevice(self, didReceiveError: .other(error))
        @unknown default:
            fatalError()
        }
    }
}

// MARK: - Private
private extension GeneralBluetoothDevice {
    func service(for characteristic: CBCharacteristic) throws -> BluetoothServiceProtocol {
        
        guard let _service = characteristic.service else {
            throw GeneralBluetoothDeviceError.cannotHandleServiceFromCaracteristic(characteristic.uuid.uuidString)
        }
        
        guard let serviceType = BluetoothServiceType(rawValue: _service.uuid.uuidString),
            let service = services[serviceType]
            else {
                // If BluetoothServiceType initializer fails or there is no such service in services dictionary than we
                // are not interesting in such changes because this means that this device is not supposed to handle it
            throw GeneralBluetoothDeviceError.cannotHandleService(_service.uuid.uuidString)
        }

        return service
    }
}

// MARK: - Private - hex value of characteristic
private extension CBCharacteristic {
    var valueHexString: String? {
        guard let value = value else { return nil }

        return "0x\(value.hexString)"
    }
}
