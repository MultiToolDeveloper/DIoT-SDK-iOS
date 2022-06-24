//
//  BluetoothStateManagerDelegate.swift
//  DIoT_Demo_iOS
//
//  Created by Andrey Maslennikov on 07.04.2022.
//

import Foundation

public protocol DIoTBluetoothManagerDelegate: class {}

/// Delegate for **BluetoothStateManagerProtocol**
public protocol DIoTBluetoothStateManagerDelegate: DIoTBluetoothManagerDelegate {
    /// Method is called when bluetooth manager recognises that bluetooth state  is undefined
    ///
    /// - Parameter manager: manager which received unknown state of central manager
    func bluetoothManagerUndefinedBluetooth(_ manager: DIoTBluetoothConnectionManagerProtocol)

    /// Method is called when bluetooth manager recognises that bluetooth is enabled on the phone
    ///
    /// - Parameter manager: manager which received poweredOn state of central manager
    func bluetoothManagerEnabledBluetooth(_ manager: DIoTBluetoothConnectionManagerProtocol)

    /// Method is called when bluetooth manager recognises that bluetooth is disabled on the phone
    ///
    /// - Parameter manager: manager which received non-poweredOn state of central manager
    func bluetoothManagerDisabledBluetooth(_ manager: DIoTBluetoothConnectionManagerProtocol)

    /// Method is called when bluetooth manager recognises that bluetooth is not allowed for the app
    ///
    /// - Parameter manager: manager which received unauthorized state of central manager
    func bluetoothManagerNotAllowedBluetooth(_ manager: DIoTBluetoothConnectionManagerProtocol)
    
    /// Method is called when bluetooth module is resetting due to some internal problems
    /// - Parameter manager: manager which received resetting state of central manager
    func bluetoothManagerResetting(_ manager: DIoTBluetoothConnectionManagerProtocol)
}

/// Delegate for **BluetoothConnectionManagerProtocol** object
public protocol DIoTBluetoothConnectionManagerDelegate: DIoTBluetoothManagerDelegate {
    /// Method is called when has been successfully connected
    ///
    /// - Parameters:
    ///   - service: service which was called `connect(to:)`
    ///   - peripheral: periperhal which has been connected
    func bluetoothManager(_ manager: DIoTBluetoothConnectionManagerProtocol, didConnectTo peripheral: PeripheralProtocol)

    /// Method is called when connection to peripheral has failed
    ///
    /// - Parameters:
    ///   - service: service which was called `connect(to:)`
    ///   - peripheral: peripheral which was not connected
    func bluetoothManager(_ manager: DIoTBluetoothConnectionManagerProtocol, didFailToConnect peripheral: PeripheralProtocol)

    /// Method is called when service disconnects from peripheral after calling `disconnect(from:)`
    ///
    /// - Parameters:
    ///   - service: services which was called `disconnect(from:)`
    ///   - peripheral: periperal which was disconnected
    func bluetoothManager(_ manager: DIoTBluetoothConnectionManagerProtocol, didDisconnectFrom peripheral: PeripheralProtocol)
}

/// Delegate for **BluetoothScanningManagerProtocol** object
public protocol DIoTBluetoothScanningManagerDelegate: DIoTBluetoothManagerDelegate {
    /// Method is called when service discovers peripheral which satisfies scanning options and services
    ///
    /// - Parameters:
    ///   - manager: service which discovered peripheral
    ///   - device: discovered `BluetoothDevice`
    ///   - rssi: rssi value. `Double`
    func bluetoothManager(
        _ manager: DIoTBluetoothScanningManagerProtocol,
        didDiscoverDevice device: DIoTBluetoothDeviceProtocol,
        rssi: Double
    )

    /// Method is called when during scanning operations an error occuires
    ///
    /// - Parameters:
    ///   - manager: manager which generated an error
    ///   - error: `BluetoothManagerScanningError`
    func bluetoothManager(
        _ manager: DIoTBluetoothScanningManagerProtocol,
        didReceiveScanningError error: DIoTBluetoothManagerScanningError
    )
}

