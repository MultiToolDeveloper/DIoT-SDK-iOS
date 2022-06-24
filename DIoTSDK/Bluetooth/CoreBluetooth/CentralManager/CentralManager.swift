//
//  CentralManager.swift
//  DIoT_Demo_iOS
//
//  Created by Andrey Maslennikov on 07.04.2022.
//

import CoreBluetooth.CBCentralManager

public final class CentralManager: NSObject {
    // CentralManagerProtocol
    weak public var delegate: CentralManagerDelegate?

    // Private
    private var materializer: CentralManagerMaterializer?
    private var object: CBCentralManager?

    // Initializer
    public init(materializer: @escaping CentralManagerMaterializer) {
        self.materializer = materializer

        super.init()
    }
}

// MARK: CentralManagerMaterializable
extension CentralManager: CentralManagerMaterializable {
    public var isMaterialized: Bool {
        return object != nil
    }

    public func materialize() {
        guard let object = materializer?() else { return }

        object.delegate = self

        self.object = object

        materializer = nil
    }
}

// MARK: CentralManagerProtocol
extension CentralManager: CentralManagerProtocol {
    @available(iOS 10.0, *)
    public var state: CBManagerState {
        guard let object = object else { return .unknown }

        return object.state
    }

    public var isScanning: Bool {
        guard let object = object else { return false }

        return object.isScanning
    }

    public func scanForPeripherals(withServices serviceUUIDs: [CBUUID]?, options: [String : Any]?) {
        guard let object = object else { return }

        object.scanForPeripherals(withServices: serviceUUIDs, options: options)
    }

    public func stopScan() {
        guard let object = object else { return }

        object.stopScan()
    }

    public func connect(_ peripheral: PeripheralProtocol, options: [String : Any]?) {
        guard let object = object, let peripheral = peripheral as? Peripheral else { return }

        object.connect(peripheral.object, options: options)
    }

    public func retrievePeripherals(withIdentifiers identifiers: [UUID]) -> [PeripheralProtocol] {
        guard let object = object else { return [] }

        let peripherals = object.retrievePeripherals(withIdentifiers: identifiers).map { $0.proxy }

        return peripherals
    }

    public func retrieveConnectedPeripherals(withServices serviceUUIDs: [CBUUID]) -> [PeripheralProtocol] {
        guard let object = object else { return [] }

        let peripherals = object.retrieveConnectedPeripherals(withServices: serviceUUIDs).map { $0.proxy }

        return peripherals
    }

    public func cancelPeripheralConnection(_ peripheral: PeripheralProtocol) {
        guard let object = object, let peripheral = peripheral as? Peripheral else { return }

        object.cancelPeripheralConnection(peripheral.object)
    }
}

// MARK: CBCentralManagerDelegate
extension CentralManager: CBCentralManagerDelegate {
    public func centralManagerDidUpdateState(_ central: CBCentralManager) {
        delegate?.centralManagerDidUpdateState(self)
    }

    public func centralManager(_ central: CBCentralManager, willRestoreState dict: [String : Any]) {
        delegate?.centralManager(self, willRestoreState: dict)
    }

    public func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        delegate?.centralManager(self, didDiscover: peripheral.proxy, advertisementData: advertisementData, rssi: RSSI)
    }

    public func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        delegate?.centralManager(self, didConnect: peripheral.proxy)
    }

    public func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        delegate?.centralManager(self, didFailToConnect: peripheral.proxy, error: error)
    }

    public func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        delegate?.centralManager(self, didDisconnectPeripheral: peripheral.proxy, error: error)
    }
}

