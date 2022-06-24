//
//  GeneralDeviceInformationBluetoothServiceProtocol.swift
//  DIoT_Demo_iOS
//
//  Created by Andrey Maslennikov on 07.04.2022.
//

public protocol GeneralDeviceInformationBluetoothServiceProtocol: BluetoothServiceProtocol {

    func fetchFirmwareVersion()
    func fetchSoftwareVersion()
    func fetchHardwareVersion()
    func fetchManufactureName()
    func fetchModelNumber()
    
    func subscribe(subscriber: GeneralDeviceInformationBluetoothServiceDelegate)
    func unsubscribe(subscriber: GeneralDeviceInformationBluetoothServiceDelegate)
}
