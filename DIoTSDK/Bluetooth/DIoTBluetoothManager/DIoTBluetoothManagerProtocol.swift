//
//  BluetoothManagerProtocol.swift
//  DIoT_Demo_iOS
//
//  Created by Andrey Maslennikov on 07.04.2022.
//

import Foundation

/// Main BluetoothManager protocol
public protocol DIoTBluetoothManagerProtocol: class {
    /// Dispatch queue in which all bluetooth stack works
    var queue: DispatchQueue { get }

    /// Subscribe the subscriber to receive events from *BluetoothManager* for specified type
    ///
    /// - Parameters:
    ///   - subscriber: object which should receive events
    ///   - to: type of delivering events
    func subscribe(_ subscriber: DIoTBluetoothManagerDelegate, to subscriptionType: DIoTBluetoothManagerSubscriptionType)

    /// Unsubscribe the subscriber to receive events from *BluetoothManager* for specified type
    ///
    /// - Parameters:
    ///   - subscriber: object which should receive events
    ///   - to: type of delivering events
    func unsubscribe(_ subscriber: DIoTBluetoothManagerDelegate, from subscriptionType: DIoTBluetoothManagerSubscriptionType)
}

/// Bluetooth manager state protocol. Defines methods to get if bluetooth is enabled on phone or not
public protocol DIoTBluetoothStateManagerProtocol: DIoTBluetoothManagerProtocol {
    /// Fetches current bluetooth power on state
    func fetchBluetoothPowerState()
}

/// Bluetooth manager scanning protocol. Defines methods with which scanning process can be started and stopped
public protocol DIoTBluetoothScanningManagerProtocol: DIoTBluetoothManagerProtocol {
    /// Starts scanning for peripherals with specified UUIDs
    ///
    /// - Parameter services: UUIDs of services looking for. If passed `nil` it will find for all possible peripherals
    /// - Parameter allowDuplicates: if set to `true` it will return one device multiple
    /// times (actually every time it is found with the system) and if set to `false`
    /// it will return only unique peripherals
    func scanForPeripherals(withServices services: [BluetoothServiceType]?, allowDuplicates: Bool)

    /// Stops scanning for peripherals
    func stopScanningForPeripherals()
}

/// Bluetooth manager connection protocol. Defines methods with which peripheral can be connected or disconnected
public protocol DIoTBluetoothConnectionManagerProtocol: DIoTBluetoothManagerProtocol {
    /// Fetches for known peripherals (cached by CoreBluetooth) with the same UUIDs
    ///
    /// - Parameters:
    ///   - identifiers: UUIDs of peripherals looking for
    ///   - competion: completion which should return peripherals
    func retrievePeripherals(withIdentifiers identifiers: [UUID], competion: @escaping ([PeripheralProtocol]) -> Void)

    /// Fetches for known peripheral (cached by CoreBluetooth) with the same UUID
    ///
    /// - Parameters:
    ///   - identifier: UUID of peripheral looking for
    ///   - competion: completion which should return peripheral
    func retrievePeripheral(withIdentifier identifier: UUID, competion: @escaping (PeripheralProtocol?) -> Void)

    /// Connect to specified peripheral
    ///
    /// - Parameter peripheral: device to connect
    func connect(to peripheral: PeripheralProtocol)

    /// Disconnect from specified peripheral
    ///
    /// - Parameter peripheral: device to disconnect
    func disconnect(from peripheral: PeripheralProtocol)
}
