//
//  BluetoothManager.swift
//  DIoT_Demo_iOS
//
//  Created by Andrey Maslennikov on 07.04.2022.
//

import CoreBluetooth

public final class DIoTBluetoothManager {
    typealias OperationBlock = () -> Void

    private let centralManager: CentralManagerProtocol
    private let deviceIdParser: DeviceIdParserProtocol

    private var connectedPeripherals: [PeripheralProtocol] = []
    private var scanForServiceUUIDs: [BluetoothServiceType]?

    private var operations: [OperationBlock] = []

    private var subscribers: [DIoTBluetoothManagerSubscriptionType: DIoTHashTable] = [:]

    public var logger: LoggerServiceProtocol?
    public let queue: DispatchQueue

    /// Init method to create instance of `BluetoothManager` to control `CentralMananger`
    ///
    /// - Parameters:
    ///   - centralManager: CentralManager to be controlled
    public init(centralManager: CentralManagerProtocol, queue: DispatchQueue) {
        self.centralManager = centralManager
        self.deviceIdParser = DeviceIdParser()
        self.queue = queue

        self.centralManager.delegate = self

        for type in DIoTBluetoothManagerSubscriptionType.allCases {
            subscribers[type] = DIoTHashTable()
        }
    }
}

// MARK: - BluetoothManagerProtocol
extension DIoTBluetoothManager: DIoTBluetoothManagerProtocol {
    public func subscribe(_ subscriber: DIoTBluetoothManagerDelegate, to subscriptionType: DIoTBluetoothManagerSubscriptionType) {
        subscribers[subscriptionType]?.add(subscriber)
    }

    public func unsubscribe(_ subscriber: DIoTBluetoothManagerDelegate, from subscriptionType: DIoTBluetoothManagerSubscriptionType) {
        subscribers[subscriptionType]?.remove(subscriber)
    }
}

// MARK: - BluetoothScanningManagerProtocol
extension DIoTBluetoothManager: DIoTBluetoothScanningManagerProtocol {
    public func startScan(withServices services: [BluetoothServiceType]?, allowDuplicates: Bool) {
        let options = [
            CBCentralManagerScanOptionAllowDuplicatesKey: allowDuplicates
        ]

        logger?.info("[Bluetooth Manager] start scanning for peripherals with services \(String(describing: services)) with options \(options)")

        scanForServiceUUIDs?.removeAll()
        scanForServiceUUIDs = services

        let serviceUUIDs = convertServicesToUUIDs(services)

        waitForCertainCentralStateIfNeeded {
            self.centralManager.scanForPeripherals(withServices: serviceUUIDs, options: options)
        }
    }

    public func stopScan() {
        logger?.info("[Bluetooth Manager] stop scanning for peripherals")

        scanForServiceUUIDs?.removeAll()

        waitForCertainCentralStateIfNeeded {
            self.centralManager.stopScan()
        }
    }
}

// MARK: - BluetoothConnectionManagerProtocol
extension DIoTBluetoothManager: DIoTBluetoothConnectionManagerProtocol {
    public func retrievePeripherals(withIdentifiers identifiers: [UUID], competion: @escaping ([PeripheralProtocol]) -> Void) {
        waitForCertainCentralStateIfNeeded {
            let peripherals = self.centralManager.retrievePeripherals(withIdentifiers: identifiers)

            competion(peripherals)
        }
    }

    public func retrievePeripheral(withIdentifier identifier: UUID, competion: @escaping (PeripheralProtocol?) -> Void) {
        waitForCertainCentralStateIfNeeded {
            let peripherals = self.centralManager.retrievePeripherals(withIdentifiers: [identifier])

            let peripheral = peripherals.first { $0.identifier == identifier }

            competion(peripheral)
        }
    }

    public func connect(to peripheral: PeripheralProtocol) {
        waitForCertainCentralStateIfNeeded {
            self.logger?.info("[Bluetooth Manager] start connecting to peripheral \(peripheral)")
            self.centralManager.connect(peripheral, options: nil)
        }
    }

    public func disconnect(from peripheral: PeripheralProtocol) {
        waitForCertainCentralStateIfNeeded {
            self.logger?.info("[Bluetooth Manager] start disconnecting from peripheral \(peripheral)")
            self.centralManager.cancelPeripheralConnection(peripheral)
        }
    }
}

// MARK: - BluetoothStateManagerProtocol
extension DIoTBluetoothManager: DIoTBluetoothStateManagerProtocol {
    public func fetchBluetoothPowerState() {
        if #available(iOS 10.0, *) {
            handle(powerState: centralManager.state)
        } else {
            // Fallback on earlier versions
        }
    }
}

// MARK: - CentralManagerDelegate
extension DIoTBluetoothManager: CentralManagerDelegate {
    public func centralManagerDidUpdateState(_ central: CentralManagerProtocol) {
        if #available(iOS 10.0, *) {
            handle(powerState: central.state)
        } else {
            // Fallback on earlier versions
        }
    }

    public func centralManager(_ central: CentralManagerProtocol, willRestoreState dict: [String : Any]) {}

    public func centralManager(_ central: CentralManagerProtocol, didConnect peripheral: PeripheralProtocol) {
        logger?.info("[Bluetooth Manager] did connect to peripheral \(peripheral)")

        append(peripheral)

        subscribers[.connection]?.forEach(as: DIoTBluetoothConnectionManagerDelegate.self) {
            $0.bluetoothManager(self, didConnectTo: peripheral)
        }
    }

    public func centralManager(_ central: CentralManagerProtocol, didFailToConnect peripheral: PeripheralProtocol, error: Error?) {
        logger?.info("[Bluetooth Manager] did fail to connect to peripheral \(peripheral) with error \(String(describing: error))")

        subscribers[.connection]?.forEach(as: DIoTBluetoothConnectionManagerDelegate.self) {
            $0.bluetoothManager(self, didFailToConnect: peripheral)
        }
    }

    public func centralManager(
        _ central: CentralManagerProtocol,
        didDisconnectPeripheral peripheral: PeripheralProtocol,
        error: Error?)
    {
        logger?.info("[Bluetooth Manager] did disconnect from peripheral \(peripheral)")

        subscribers[.connection]?.forEach(as: DIoTBluetoothConnectionManagerDelegate.self) {
            $0.bluetoothManager(self, didDisconnectFrom: peripheral)
        }

        remove(peripheral)
    }

    public func centralManager(
        _ central: CentralManagerProtocol,
        didDiscover peripheral: PeripheralProtocol,
        advertisementData: [String : Any],
        rssi: NSNumber)
    {
        guard let manufactureData = advertisementData[CBAdvertisementDataManufacturerDataKey] as? Data else { return }
        guard let deviceName = advertisementData[CBAdvertisementDataLocalNameKey] as? NSString else { return }

        do {
            let deviceId = try deviceIdParser.parseDeviceId(hexString: manufactureData.hexString)

            let bluetoothDevice = GeneralBluetoothDevice(
                peripheral: peripheral,
                deviceId: deviceId,
                deviceName: String(deviceName),
                queue: queue
            )

            bluetoothDevice.logger = logger
            bluetoothDevice.manager = self
            
            let diotDevice = DIoTBluetoothDevice(generalDevice: bluetoothDevice)

            subscribers[.scan]?.forEach(as: DIoTBluetoothScanningManagerDelegate.self) {
                $0.bluetoothManager(self,
                                    didDiscoverDevice: diotDevice,
                                    rssi: rssi.doubleValue)
            }
        } catch {
            handleScanningError(error)
        }
    }
}

// MARK: - Handle power state
@available(iOS 10.0, *)
private extension DIoTBluetoothManager {
    func handle(powerState state: CBManagerState) {
        logger?.info("[Bluetooth Manager] power state changed to \(state)")

        switch state {
        case .unknown:
            operations.removeAll()

            subscribers[.state]?.forEach(as: DIoTBluetoothStateManagerDelegate.self) {
                $0.bluetoothManagerUndefinedBluetooth(self)
            }

        case .unsupported, .poweredOff:
            operations.removeAll()

            subscribers[.state]?.forEach(as: DIoTBluetoothStateManagerDelegate.self) {
                $0.bluetoothManagerDisabledBluetooth(self)
            }

        case .resetting:
            logger?.info("Did update central manager state to resetting.")
            operations.removeAll()
            
            subscribers[.state]?.forEach(as: DIoTBluetoothStateManagerDelegate.self) {
                $0.bluetoothManagerResetting(self)
            }

        case .unauthorized:
            operations.removeAll()

            subscribers[.state]?.forEach(as: DIoTBluetoothStateManagerDelegate.self) {
                $0.bluetoothManagerNotAllowedBluetooth(self)
            }

        case .poweredOn:
            performAllOperationsWaitingForState()

            subscribers[.state]?.forEach(as: DIoTBluetoothStateManagerDelegate.self) {
                $0.bluetoothManagerEnabledBluetooth(self)
            }

        @unknown default:
            fatalError()
        }
    }

    private func performAllOperationsWaitingForState() {
        logger?.info("[Bluetooth Manager] perform waiting operations")

        while !operations.isEmpty {
            let operation = operations.removeFirst()

            operation()
        }
    }
}

// MARK: - Save connected and delete disconnected peripherals
private extension DIoTBluetoothManager {
    func append(_ peripheral: PeripheralProtocol) {
        func contains(_ peripheral: PeripheralProtocol) -> Bool {
            return connectedPeripherals.contains(where: { $0.identifier == peripheral.identifier })
        }

        guard !contains(peripheral) else { return }

        self.connectedPeripherals.append(peripheral)
    }

    func remove(_ peripheral: PeripheralProtocol) {
        guard let index = connectedPeripherals.firstIndex(where: { $0.identifier == peripheral.identifier }) else { return }

        _ = self.connectedPeripherals.remove(at: index)
    }
}

// MARK: - Converting services to CBUUIDs
private extension DIoTBluetoothManager {
    func convertServicesToUUIDs(_ services: [BluetoothServiceType]?) -> [CBUUID]? {
        guard let services = services, !services.isEmpty else { return nil }

        return services
            .compactMap({ $0.rawValue })
            .map(CBUUID.init)
    }
}

// MARK: - Handling errors
private extension DIoTBluetoothManager {
    func handleScanningError(_ error: Error) {
        if let error = error as? DeviceIdError { handleAdvertisementParsingError(error) }
    }

    private func handleAdvertisementParsingError(_ error: DeviceIdError) {
        subscribers[.scan]?.forEach(as: DIoTBluetoothScanningManagerDelegate.self) {
            $0.bluetoothManager(self, didReceiveScanningError: .cannotParseAdvertisementId(error))
        }
    }
}

// MARK: - Private
private extension DIoTBluetoothManager {
    func waitForCertainCentralStateIfNeeded(_ block: @escaping OperationBlock) {
        let item = DispatchWorkItem(block: block)

        if #available(iOS 10.0, *) {
            if centralManager.state == .poweredOn {
                queue.async(execute: item)
            } else if centralManager.state == .unknown {
                operations.append(block)
            }
        } else {
            queue.async(execute: item)
        }
    }
}

// MARK: - Constants
private extension DIoTBluetoothManager {
    enum Advertisement {
        static let serviceData = CBUUID(string: "FFFE")
    }
}
