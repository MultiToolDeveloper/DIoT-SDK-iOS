//
//  GeneralBatteryBluetoothServiceProtocol.swift
//  DIoT_Demo_iOS
//
//  Created by Andrey Maslennikov on 07.04.2022.
//

public protocol GeneralBatteryBluetoothServiceProtocol: BluetoothServiceProtocol {

    func fetchBatteryLevel()
    func notifyBatteryLevel(enable: Bool)
    
    func subscribe(subscriber: GeneralBatteryBluetoothServiceDelegate)
    func unsubscribe(subscriber: GeneralBatteryBluetoothServiceDelegate)

}
