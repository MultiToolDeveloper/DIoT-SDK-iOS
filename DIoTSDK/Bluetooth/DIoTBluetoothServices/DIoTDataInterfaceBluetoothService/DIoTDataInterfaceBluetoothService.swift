//
//  DIoTDataInterfaceBluetoothService.swift
//  DIoT_Demo_iOS
//
//  Created by Andrey Maslennikov on 13.04.2022.
//

import Foundation
import CoreBluetooth.CBService

final class DIoTDataInterfaceBluetoothService: BluetoothService {

    private var subscribers = DIoTHashTable()
    
    override func handleDidUpdateValue(for bluetoothCharacteristic: CBCharacteristic) {
        guard let characteristic = DIoTDataInterfaceBluetoothServiceCharacteristics(rawValue: bluetoothCharacteristic.uuid.uuidString) else { return }

        handleUpdateValue(bluetoothCharacteristic.value, for: characteristic)
    }

    override func handleDidWriteValue(for bluetoothCharacteristic: CBCharacteristic) {
        // No need
    }

    override func handleDidUpdateNotificationState(for bluetoothCharacteristic: CBCharacteristic) {
        guard let characteristic = DIoTDataInterfaceBluetoothServiceCharacteristics(rawValue: bluetoothCharacteristic.uuid.uuidString) else { return }

        handleUpdateSubscription(bluetoothCharacteristic, characteristic)
    }
}

// MARK: - DataInterfaceBluetoothServiceProtocol
extension DIoTDataInterfaceBluetoothService: DIoTDataInterfaceBluetoothServiceProtocol {
    
    func subscribe(subscriber: DIoTDataInterfaceBluetoothServiceDelegate) {
        if !subscribers.contains(subscriber) {
            subscribers.add(subscriber)
        }
    }
    
    func unsubscribe(subscriber: DIoTDataInterfaceBluetoothServiceDelegate) {
        if subscribers.contains(subscriber) {
            subscribers.remove(subscriber)
        }
    }
    
    func fetchData(channelNumber: Int) {
        switch channelNumber {
        case 1:
            readValue(for: DIoTDataInterfaceBluetoothServiceCharacteristics.dataChannel1)
        case 2:
            readValue(for: DIoTDataInterfaceBluetoothServiceCharacteristics.dataChannel2)
        case 3:
            readValue(for: DIoTDataInterfaceBluetoothServiceCharacteristics.dataChannel3)
        case 4:
            readValue(for: DIoTDataInterfaceBluetoothServiceCharacteristics.dataChannel4)
        case 5:
            readValue(for: DIoTDataInterfaceBluetoothServiceCharacteristics.dataChannel5)
        case 6:
            readValue(for: DIoTDataInterfaceBluetoothServiceCharacteristics.dataChannel6)
        case 7:
            readValue(for: DIoTDataInterfaceBluetoothServiceCharacteristics.dataChannel7)
        case 8:
            readValue(for: DIoTDataInterfaceBluetoothServiceCharacteristics.dataChannel8)
        case 9:
            readValue(for: DIoTDataInterfaceBluetoothServiceCharacteristics.dataChannel9)
        default:
            readValue(for: DIoTDataInterfaceBluetoothServiceCharacteristics.dataChannel1)
        }
    }
    
    func notifyData(channelNumber: Int, enable: Bool){
        switch channelNumber {
        case 1:
            setNotifyValue(enable, for: DIoTDataInterfaceBluetoothServiceCharacteristics.dataChannel1)
        case 2:
            setNotifyValue(enable, for: DIoTDataInterfaceBluetoothServiceCharacteristics.dataChannel2)
        case 3:
            setNotifyValue(enable, for: DIoTDataInterfaceBluetoothServiceCharacteristics.dataChannel3)
        case 4:
            setNotifyValue(enable, for: DIoTDataInterfaceBluetoothServiceCharacteristics.dataChannel4)
        case 5:
            setNotifyValue(enable, for: DIoTDataInterfaceBluetoothServiceCharacteristics.dataChannel5)
        case 6:
            setNotifyValue(enable, for: DIoTDataInterfaceBluetoothServiceCharacteristics.dataChannel6)
        case 7:
            setNotifyValue(enable, for: DIoTDataInterfaceBluetoothServiceCharacteristics.dataChannel7)
        case 8:
            setNotifyValue(enable, for: DIoTDataInterfaceBluetoothServiceCharacteristics.dataChannel8)
        case 9:
            setNotifyValue(enable, for: DIoTDataInterfaceBluetoothServiceCharacteristics.dataChannel9)
        default:
            return
        }
        
    }
}

// MARK: - Handle update values
private extension DIoTDataInterfaceBluetoothService {
    func handleUpdateValue(_ value: Data?, for characteristic: DIoTDataInterfaceBluetoothServiceCharacteristics) {
        guard let data = value else { return }

        switch characteristic {
        case .dataChannel1:
            handleUpdateDataChannelValue(1, data)
            break
        case .dataChannel2:
            handleUpdateDataChannelValue(2, data)
            break
        case .dataChannel3:
            handleUpdateDataChannelValue(3, data)
            break
        case .dataChannel4:
            handleUpdateDataChannelValue(4, data)
            break
        case .dataChannel5:
            handleUpdateDataChannelValue(5, data)
            break
        case .dataChannel6:
            handleUpdateDataChannelValue(6, data)
            break
        case .dataChannel7:
            handleUpdateDataChannelValue(7, data)
            break
        case .dataChannel8:
            handleUpdateDataChannelValue(8, data)
            break
        case .dataChannel9:
            handleUpdateDataChannelValue(9, data)
            break
        }
    }

    private func handleUpdateDataChannelValue(_ number: Int, _ data: Data) {
        do {
            let value = try DataInterfaceParser.value(from: data)
            subscribers.forEach(as: DIoTDataInterfaceBluetoothServiceDelegate.self) {
                $0.dataInterfaceBluetoothService(self, didReceiveDataChannel: value, channelNumber: number)
            }
        } catch {
            handle(error: error)
        }
    }
}


// MARK: - Handle subscribe values
private extension DIoTDataInterfaceBluetoothService {
    func handleUpdateSubscription(_ bluetoothCharacteristic: CBCharacteristic, _ generalCharacteristic: DIoTDataInterfaceBluetoothServiceCharacteristics) {
        switch generalCharacteristic {
        case .dataChannel1:
            handleUpdateDataSubscription(bluetoothCharacteristic, channelNum: 1)
            break
        case .dataChannel2:
            handleUpdateDataSubscription(bluetoothCharacteristic, channelNum: 2)
            break
        case .dataChannel3:
            handleUpdateDataSubscription(bluetoothCharacteristic, channelNum: 3)
            break
        case .dataChannel4:
            handleUpdateDataSubscription(bluetoothCharacteristic, channelNum: 4)
            break
        case .dataChannel5:
            handleUpdateDataSubscription(bluetoothCharacteristic, channelNum: 5)
            break
        case .dataChannel6:
            handleUpdateDataSubscription(bluetoothCharacteristic, channelNum: 6)
            break
        case .dataChannel7:
            handleUpdateDataSubscription(bluetoothCharacteristic, channelNum: 7)
            break
        case .dataChannel8:
            handleUpdateDataSubscription(bluetoothCharacteristic, channelNum: 8)
            break
        case .dataChannel9:
            handleUpdateDataSubscription(bluetoothCharacteristic, channelNum: 9)
            break
        }
    }
    
    private func handleUpdateDataSubscription(_ characteristic: CBCharacteristic, channelNum: Int) {
        subscribers.forEach(as: DIoTDataInterfaceBluetoothServiceDelegate.self) {
            $0.dataInterfaceBluetoothService(self, subscriptionDataChannelStatusChange: characteristic.isNotifying, channelNumber: channelNum)
        }
    }
    
}

// MARK: - Handle errors
private extension DIoTDataInterfaceBluetoothService {
    func handle(error: Error) {
        if let parseError = error as? BluetoothCharacteristicValueParserError {
            handle(parseError: parseError)
        }
    }

    private func handle(parseError: BluetoothCharacteristicValueParserError) {
        subscribers.forEach(as: DIoTDataInterfaceBluetoothServiceDelegate.self) {
            $0.dataInterfaceBluetoothService(self, didReceiveError: .cannotParse(parseError))
        }
    }
}
