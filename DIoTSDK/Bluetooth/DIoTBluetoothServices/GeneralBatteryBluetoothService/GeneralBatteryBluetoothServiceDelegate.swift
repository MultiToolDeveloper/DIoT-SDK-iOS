//
//  GeneralBatteryBluetoothServiceDelegate.swift
//  DIoT_Demo_iOS
//
//  Created by Andrey Maslennikov on 07.04.2022.
//

public protocol GeneralBatteryBluetoothServiceDelegate: class {
    /// Calls after service receives battery level from *CBService*
    ///
    /// - Parameters:
    ///   - service: battery service
    ///   - level: current level of battery
    func batteryService(_ service: GeneralBatteryBluetoothServiceProtocol, didReceiveLevel level: UInt)
    func batteryService(_ service: GeneralBatteryBluetoothServiceProtocol, subscriptionStatusChange enabled: Bool)
}
