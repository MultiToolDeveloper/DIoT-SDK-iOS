//
//  DIoTDeviceIdBluetoothServiceProtocol.swift
//  DIoT_Demo_iOS
//
//  Created by Andrey Maslennikov on 07.04.2022.
//

public protocol DIoTDeviceIdBluetoothServiceProtocol: BluetoothServiceProtocol {

    func fetchChipIdentier()
    
    func subscribe(subscriber: DIoTDeviceIdBluetoothServiceDelegate)
    func unsubscribe(subscriber: DIoTDeviceIdBluetoothServiceDelegate)
}
