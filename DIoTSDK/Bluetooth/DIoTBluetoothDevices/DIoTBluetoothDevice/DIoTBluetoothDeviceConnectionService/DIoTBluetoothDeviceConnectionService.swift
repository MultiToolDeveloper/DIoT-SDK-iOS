//
//  DIoTBluetoothConnectionService.swift
//  DIoT_Demo_iOS
//
//  Created by Andrey Maslennikov on 21.06.2022.
//

import Foundation

public final class DIoTBluetoothDeviceConnectionService {
    
    let generalDevice: GeneralBluetoothDeviceProtocol
    let diotDevice: DIoTBluetoothDeviceProtocol
    
    var subscribers = DIoTHashTable()

    public init(generalDevice: GeneralBluetoothDeviceProtocol, diotDevice: DIoTBluetoothDevice) {
        self.generalDevice = generalDevice
        self.diotDevice = diotDevice
        
        generalDevice.delegate = self
    }
}

extension DIoTBluetoothDeviceConnectionService: DIoTBluetoothDeviceConnectionServiceProtocol {
    public func connect() {
        generalDevice.connect()
    }
    
    public func disconnect() {
        generalDevice.disconnect()
    }
    
    public func readRSSI() {
        generalDevice.fetchRSSI()
    }
    
    public func subscribe(subscriber: DIoTBluetoothDeviceConnectionServiceDelegate) {
        if !subscribers.contains(subscriber) {
            subscribers.add(subscriber)
        }
    }
    
    public func unsubscribe(subscriber: DIoTBluetoothDeviceConnectionServiceDelegate) {
        if subscribers.contains(subscriber) {
            subscribers.remove(subscriber)
        }
    }
}

extension DIoTBluetoothDeviceConnectionService: GeneralBluetoothDeviceDelegate {
    public func bluetoothDevice(_ device: GeneralBluetoothDeviceProtocol, didReceiveRSSI rssi: Double) {
        subscribers.forEach(as: DIoTBluetoothDeviceConnectionServiceDelegate.self) {
            $0.diotDevice(self, didReceiveRSSI: rssi)
        }
    }
    
    public func bluetoothDeviceDidConnect(_ device: GeneralBluetoothDeviceProtocol) {
        //do some additional setup
        
        //subscribe on some available services
        diotDevice.commandInterfaceService?.notifyFeatures(enable: true)
        diotDevice.commandInterfaceService?.notifyChannels(enable: true)
        diotDevice.commandInterfaceService?.notifyRates(enable: true)
        diotDevice.batteryService?.notifyBatteryLevel(enable: true)
//        diotDevice.debugService?.notifyDebug(true)
//        diotDevice.dataInterfaceService?.notifyData(1, true)
//        diotDevice.dataInterfaceService?.notifyData(2, true)
//        diotDevice.dataInterfaceService?.notifyData(3, true)
//        diotDevice.dataInterfaceService?.notifyData(4, true)
//        diotDevice.dataInterfaceService?.notifyData(5, true)
//        diotDevice.dataInterfaceService?.notifyData(6, true)
//        diotDevice.dataInterfaceService?.notifyData(7, true)
//        diotDevice.dataInterfaceService?.notifyData(8, true)
//        diotDevice.dataInterfaceService?.notifyData(9, true)
        
        subscribers.forEach(as: DIoTBluetoothDeviceConnectionServiceDelegate.self) {
            $0.diotDeviceDidConnect(self)
        }
    }
    
    public func bluetoothDeviceDidDisconnect(_ device: GeneralBluetoothDeviceProtocol) {
        subscribers.forEach(as: DIoTBluetoothDeviceConnectionServiceDelegate.self) {
            $0.diotDeviceDidDisconnect(self)
        }
    }
    
    public func bluetoothDeviceDidFailToConnect(_ device: GeneralBluetoothDeviceProtocol) {
        subscribers.forEach(as: DIoTBluetoothDeviceConnectionServiceDelegate.self) {
            $0.diotDeviceDidFailToConnect(self)
        }
    }
    
    public func bluetoothDevice(_ device: GeneralBluetoothDeviceProtocol, didReceiveError error: GeneralBluetoothDeviceError) {
        switch (error){
        case .serviceUnavaliable(let service):
            subscribers.forEach(as: DIoTBluetoothDeviceConnectionServiceDelegate.self) {
                $0.diotDevice(self, didReceiveError: .serviceUnavaliable(service))
            }
        case .cannotHandleService(let service):
            subscribers.forEach(as: DIoTBluetoothDeviceConnectionServiceDelegate.self) {
                $0.diotDevice(self, didReceiveError: .cannotHandleService(service))
            }
        case .cannotHandleServiceFromCaracteristic(let characteristic):
            subscribers.forEach(as: DIoTBluetoothDeviceConnectionServiceDelegate.self) {
                $0.diotDevice(self, didReceiveError: .cannotHandleServiceFromCaracteristic(characteristic))
            }
        case .connectionError:
            subscribers.forEach(as: DIoTBluetoothDeviceConnectionServiceDelegate.self) {
                $0.diotDevice(self, didReceiveError: .connectionError)
            }
        case .other(let error):
            subscribers.forEach(as: DIoTBluetoothDeviceConnectionServiceDelegate.self) {
                $0.diotDevice(self, didReceiveError: .other(error))
            }
        }
    }
    
}
