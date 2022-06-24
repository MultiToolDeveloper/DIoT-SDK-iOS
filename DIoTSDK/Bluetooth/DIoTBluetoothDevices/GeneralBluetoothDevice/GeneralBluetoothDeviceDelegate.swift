//
//  BluetoothDeviceDelegate.swift
//  DIoT_Demo_iOS
//
//  Created by Andrey Maslennikov on 07.04.2022.
//

public protocol GeneralBluetoothDeviceDelegate: class {
    /// Returns current rssi value after calling *fetchRSSI* at **DeviceProtocol**
    ///
    /// - Parameters:
    ///   - device: device which rssi is received
    ///   - rssi: RSSI value
    func bluetoothDevice(_ device: GeneralBluetoothDeviceProtocol, didReceiveRSSI rssi: Double)

    /// Method is called when device is connected
    ///
    /// - Parameter device: device which has been connected
    func bluetoothDeviceDidConnect(_ device: GeneralBluetoothDeviceProtocol)

    /// Method is called when device is disconnected
    ///
    /// - Parameter device: device which has been disconnected
    func bluetoothDeviceDidDisconnect(_ device: GeneralBluetoothDeviceProtocol)

    /// Method is called when device fails to connect
    ///
    /// - Parameter device: device which was trying to connect
    func bluetoothDeviceDidFailToConnect(_ device: GeneralBluetoothDeviceProtocol)

    /// Method is called when device receives some error
    ///
    /// - Parameters:
    ///   - device: device which received error
    ///   - error: error `BluetoothDeviceError`
    func bluetoothDevice(_ device: GeneralBluetoothDeviceProtocol, didReceiveError error: GeneralBluetoothDeviceError)
}
