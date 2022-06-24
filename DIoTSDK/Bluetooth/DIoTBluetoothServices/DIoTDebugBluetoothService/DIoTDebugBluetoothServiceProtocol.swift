//
//  DIoTDebugBluetoothServiceProtocol.swift
//  DIoT_Demo_iOS
//
//  Created by Andrey Maslennikov on 07.04.2022.
//

public protocol DIoTDebugBluetoothServiceProtocol: BluetoothServiceProtocol {
    
    func sendDebug(command: String)
    func notifyDebug(enable: Bool)
    
    func subscribe(subscriber: DIoTDebugBluetoothServiceDelegate)
    func unsubscribe(subscriber: DIoTDebugBluetoothServiceDelegate)
}

