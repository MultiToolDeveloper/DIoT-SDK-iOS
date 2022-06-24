//
//  DIoTBluetoothConnectionServiceProtocol.swift
//  DIoT_Demo_iOS
//
//  Created by Andrey Maslennikov on 21.06.2022.
//

import Foundation

public protocol DIoTBluetoothDeviceConnectionServiceProtocol {

    func connect()
    func disconnect()
    func readRSSI()

    func subscribe(subscriber: DIoTBluetoothDeviceConnectionServiceDelegate)
    func unsubscribe(subscriber: DIoTBluetoothDeviceConnectionServiceDelegate)
}
