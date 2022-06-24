//
//  BluetoothDeviceProtocol.swift
//  DIoT_Demo_iOS
//
//  Created by Andrey Maslennikov on 07.04.2022.
//

/// Main protocol for all bluetooth devices
public protocol GeneralBluetoothDeviceProtocol: class {
    var delegate: GeneralBluetoothDeviceDelegate? { get set }

    var deviceId: DeviceId { get }
    var deviceName: String { get }
    var peripheral: PeripheralProtocol { get }
    var manager: (DIoTBluetoothScanningManagerProtocol & DIoTBluetoothConnectionManagerProtocol)? { get set }

    var services: [BluetoothServiceType: BluetoothServiceProtocol] { get }

    /// Connects to this device
    func connect()

    /// Disconnects from this device
    func disconnect()

    /// Fetches current RSSI this device
    func fetchRSSI()
}
