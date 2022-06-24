//
//  DIoTDataInterfaceBluetoothServiceProtocol.swift
//  DIoT_Demo_iOS
//
//  Created by Andrey Maslennikov on 07.04.2022.
//

import Foundation

public protocol DIoTDataInterfaceBluetoothServiceProtocol: BluetoothServiceProtocol {
    
    func fetchData(channelNumber: Int)
    func notifyData(channelNumber: Int, enable: Bool)
    
    func subscribe(subscriber: DIoTDataInterfaceBluetoothServiceDelegate)
    func unsubscribe(subscriber: DIoTDataInterfaceBluetoothServiceDelegate)
}
