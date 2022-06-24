//
//  DIoTBluetoothProtocol.swift
//  DIoT_Demo_iOS
//
//  Created by Andrey Maslennikov on 07.04.2022.
//

public protocol DIoTBluetoothDeviceProtocol {

    var name: String { get }
    var deviceId: DeviceId { get }
    var address: String { get }
    
    var connectionService: DIoTBluetoothDeviceConnectionServiceProtocol? { get }
    var deviceInformationService: GeneralDeviceInformationBluetoothServiceProtocol? { get }
    var batteryService: GeneralBatteryBluetoothServiceProtocol? { get }
    var commandInterfaceService: DIoTCommandInterfaceBluetoothServiceProtocol? { get }
    var dataInterfaceService: DIoTDataInterfaceBluetoothServiceProtocol? { get }
    var deviceIdentifierService: DIoTDeviceIdBluetoothServiceProtocol? { get }
    var debugService: DIoTDebugBluetoothServiceProtocol? { get }
}
