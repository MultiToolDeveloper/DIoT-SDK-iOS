//
//  CentralManagerProtocol.swift
//  DIoT_Demo_iOS
//
//  Created by Andrey Maslennikov on 07.04.2022.
//

import CoreBluetooth

public protocol CentralManagerProtocol: class {
    var delegate: CentralManagerDelegate? { get set }

    @available(iOS 10.0, *)
    var state: CBManagerState { get }
    
    var isScanning: Bool { get }

    func retrievePeripherals(withIdentifiers identifiers: [UUID]) -> [PeripheralProtocol]
    func retrieveConnectedPeripherals(withServices serviceUUIDs: [CBUUID]) -> [PeripheralProtocol]

    func scanForPeripherals(withServices serviceUUIDs: [CBUUID]?, options: [String : Any]?)
    func stopScan()
    func connect(_ peripheral: PeripheralProtocol, options: [String : Any]?)
    func cancelPeripheralConnection(_ peripheral: PeripheralProtocol)
}
