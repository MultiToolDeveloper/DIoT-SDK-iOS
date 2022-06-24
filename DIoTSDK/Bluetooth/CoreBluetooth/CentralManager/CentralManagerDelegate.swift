//
//  CentralManagerDelegate.swift
//  DIoT_Demo_iOS
//
//  Created by Andrey Maslennikov on 07.04.2022.
//

import Foundation

public protocol CentralManagerDelegate: class {
    func centralManagerDidUpdateState(_ central: CentralManagerProtocol)
    func centralManager(_ central: CentralManagerProtocol, willRestoreState dict: [String : Any])
    func centralManager(_ central: CentralManagerProtocol, didDiscover peripheral: PeripheralProtocol, advertisementData: [String : Any], rssi RSSI: NSNumber)
    func centralManager(_ central: CentralManagerProtocol, didConnect peripheral: PeripheralProtocol)
    func centralManager(_ central: CentralManagerProtocol, didFailToConnect peripheral: PeripheralProtocol, error: Error?)
    func centralManager(_ central: CentralManagerProtocol, didDisconnectPeripheral peripheral: PeripheralProtocol, error: Error?)
}
