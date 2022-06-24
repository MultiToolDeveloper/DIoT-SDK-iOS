//
//  DIoTCommandInterfaceBluetoothServiceProtocol.swift
//  DIoT_Demo_iOS
//
//  Created by Andrey Maslennikov on 07.04.2022.
//

import Foundation

public protocol DIoTCommandInterfaceBluetoothServiceProtocol: BluetoothServiceProtocol {

    func fetchFeatures()
    func fetchChannels()
    func fetchRates()
    func fetchFeature(code: DIoTFeatureCode)
    func fetchChannel(channel: Int)
    func fetchRate(channel: Int)
    func notifyFeatures(enable: Bool)
    func notifyChannels(enable: Bool)
    func notifyRates(enable: Bool)

    func setFeature(feature: DIoTFeatureData)
    func cleanFeature(code: DIoTFeatureCode)
    func cleanFeatures()
    func setChannel(channel: Int, code: DIoTFeatureCode)
    func cleanChannel(channel: Int)
    func cleanChannels()
    func setRate(channel: Int, rate: UInt32)
    func cleanRate(channel: Int)
    func cleanRates()
    
    func subscribe(subscriber: DIoTCommandInterfaceBluetoothServiceDelegate)
    func unsubscribe(subscriber: DIoTCommandInterfaceBluetoothServiceDelegate)
}
