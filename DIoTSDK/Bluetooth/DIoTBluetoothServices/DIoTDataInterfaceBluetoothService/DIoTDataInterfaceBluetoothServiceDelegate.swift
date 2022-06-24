//
//  DIoTDataInterfaceBluetoothServiceDelegate.swift
//  DIoT_Demo_iOS
//
//  Created by Andrey Maslennikov on 07.04.2022.
//

import Foundation

public protocol DIoTDataInterfaceBluetoothServiceDelegate: class {
    func dataInterfaceBluetoothService(_ service: DIoTDataInterfaceBluetoothServiceProtocol, didReceiveDataChannel features: [DIoTFeatureData], channelNumber: Int)
    func dataInterfaceBluetoothService(_ service: DIoTDataInterfaceBluetoothServiceProtocol, didReceiveError error: DIoTDataInterfaceBluetoothServiceError)
    func dataInterfaceBluetoothService(_ service: DIoTDataInterfaceBluetoothServiceProtocol, subscriptionDataChannelStatusChange enabled: Bool, channelNumber: Int)

}
