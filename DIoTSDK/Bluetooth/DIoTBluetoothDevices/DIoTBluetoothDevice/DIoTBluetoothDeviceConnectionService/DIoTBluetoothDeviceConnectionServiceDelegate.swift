//
//  DIoTBluetoothConnectionServiceDelegate.swift
//  DIoT_Demo_iOS
//
//  Created by Andrey Maslennikov on 21.06.2022.
//

import Foundation

public protocol DIoTBluetoothDeviceConnectionServiceDelegate: class {
    func diotDevice(_ service: DIoTBluetoothDeviceConnectionServiceProtocol, didReceiveRSSI rssi: Double)
    func diotDeviceDidConnect(_ service: DIoTBluetoothDeviceConnectionServiceProtocol)
    func diotDeviceDidDisconnect(_ service: DIoTBluetoothDeviceConnectionServiceProtocol)
    func diotDeviceDidFailToConnect(_ service: DIoTBluetoothDeviceConnectionServiceProtocol)
    func diotDevice(_ service: DIoTBluetoothDeviceConnectionServiceProtocol, didReceiveError error: GeneralBluetoothDeviceError)
}
