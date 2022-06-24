//
//  DIoTBluetooth.swift
//  DIoT_Demo_iOS
//
//  Created by Andrey Maslennikov on 07.04.2022.
//

public final class DIoTBluetoothDevice {
    
    private let generalDevice: GeneralBluetoothDeviceProtocol
    private var dIoTBluetoothDeviceConnectionService: DIoTBluetoothDeviceConnectionServiceProtocol? = nil
    
    public init(generalDevice: GeneralBluetoothDeviceProtocol) {
        self.generalDevice = generalDevice
        self.dIoTBluetoothDeviceConnectionService = DIoTBluetoothDeviceConnectionService(generalDevice: generalDevice, diotDevice: self)
    }
}

// MARK: - DIoTBluetoothDeviceProtocol
extension DIoTBluetoothDevice: DIoTBluetoothDeviceProtocol {
    
    public var name: String {
        return generalDevice.deviceName
    }
    
    public var deviceId: DeviceId {
        return generalDevice.deviceId
    }
    
    public var address: String {
        generalDevice.peripheral.identifier.uuidString
    }
    
    public var connectionService: DIoTBluetoothDeviceConnectionServiceProtocol? {
        return dIoTBluetoothDeviceConnectionService
    }
    
    public var deviceInformationService: GeneralDeviceInformationBluetoothServiceProtocol? {
            return generalDevice.services[.deviceInformation] as? GeneralDeviceInformationBluetoothServiceProtocol
        }
    
    public var batteryService: GeneralBatteryBluetoothServiceProtocol? {
        return generalDevice.services[.battery] as? GeneralBatteryBluetoothServiceProtocol
    }
    
    public var commandInterfaceService: DIoTCommandInterfaceBluetoothServiceProtocol? {
        return generalDevice.services[.command] as? DIoTCommandInterfaceBluetoothServiceProtocol
    }
    
    public var dataInterfaceService: (DIoTDataInterfaceBluetoothServiceProtocol)? {
        return generalDevice.services[.data] as? DIoTDataInterfaceBluetoothServiceProtocol
    }
    
    public var deviceIdentifierService: DIoTDeviceIdBluetoothServiceProtocol? {
        return generalDevice.services[.deviceIdentifier] as? DIoTDeviceIdBluetoothServiceProtocol
    }

    public var debugService: DIoTDebugBluetoothServiceProtocol? {
        return generalDevice.services[.debug] as? DIoTDebugBluetoothServiceProtocol
    }
}

// MARK: Equatable
extension DIoTBluetoothDevice: Equatable {
    public static func == (lhs: DIoTBluetoothDevice, rhs: DIoTBluetoothDevice) -> Bool {
        return (lhs.generalDevice.deviceId == rhs.generalDevice.deviceId)
    }
}

