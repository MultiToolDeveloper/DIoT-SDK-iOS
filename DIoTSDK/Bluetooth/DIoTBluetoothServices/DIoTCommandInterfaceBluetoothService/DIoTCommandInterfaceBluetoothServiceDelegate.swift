//
//  DIoTCommandInterfaceBluetoothServiceDelegate.swift
//  DIoT_Demo_iOS
//
//  Created by Andrey Maslennikov on 07.04.2022.
//

import Foundation

public protocol DIoTCommandInterfaceBluetoothServiceDelegate: class {
    func commandInterfaceBluetoothService(_ service: DIoTCommandInterfaceBluetoothServiceProtocol, didReceiveCommandFeatures features: [DIoTFeatureData])
    func commandInterfaceBluetoothService(_ service: DIoTCommandInterfaceBluetoothServiceProtocol, didReceiveCommandChannels channels: [DIoTChannelData])
    func commandInterfaceBluetoothService(_ service: DIoTCommandInterfaceBluetoothServiceProtocol, didReceiveCommandRate rates: [DIoTRateData])
    func commandInterfaceBluetoothService(_ service: DIoTCommandInterfaceBluetoothServiceProtocol, didReceiveError error: DIoTCommandInterfaceBluetoothServiceError)
    
    func commandInterfaceBluetoothServiceDidWriteCommandFeatures(_ service: DIoTCommandInterfaceBluetoothServiceProtocol)
    func commandInterfaceBluetoothServiceDidWriteCommandChannels(_ service: DIoTCommandInterfaceBluetoothServiceProtocol)
    func commandInterfaceBluetoothServiceDidWriteCommandRate(_ service: DIoTCommandInterfaceBluetoothServiceProtocol)
    
    func commandInterfaceBluetoothService(_ service: DIoTCommandInterfaceBluetoothServiceProtocol, subscriptionFeaturesStatusChange enabled: Bool)
    func commandInterfaceBluetoothService(_ service: DIoTCommandInterfaceBluetoothServiceProtocol, subscriptionChannelsStatusChange enabled: Bool)
    func commandInterfaceBluetoothService(_ service: DIoTCommandInterfaceBluetoothServiceProtocol, subscriptionRatesStatusChange enabled: Bool)
}
