//
//  DIoTCommandInterfaceBluetoothService.swift
//  DIoT_Demo_iOS
//
//  Created by Andrey Maslennikov on 07.04.2022.
//

import Foundation
import CoreBluetooth.CBService

final class DIoTCommandInterfaceBluetoothService: BluetoothService {

    private var subscribers = DIoTHashTable()

    override func handleDidUpdateValue(for bluetoothCharacteristic: CBCharacteristic) {
        guard let characteristic = DIoTCommandInterfaceBluetoothServiceCharacteristics(rawValue: bluetoothCharacteristic.uuid.uuidString) else { return }

        handleUpdateValue(bluetoothCharacteristic.value, for: characteristic)
    }

    override func handleDidWriteValue(for bluetoothCharacteristic: CBCharacteristic) {
        guard let characteristic = DIoTCommandInterfaceBluetoothServiceCharacteristics(rawValue: bluetoothCharacteristic.uuid.uuidString) else { return }

        handleWriteValue(for: characteristic)
    }

    override func handleDidUpdateNotificationState(for bluetoothCharacteristic: CBCharacteristic) {
        guard let characteristic = DIoTCommandInterfaceBluetoothServiceCharacteristics(rawValue: bluetoothCharacteristic.uuid.uuidString) else { return }

        handleUpdateSubscription(bluetoothCharacteristic, characteristic)
    }
}

// MARK: - CommandInterfaceBluetoothServiceProtocol
extension DIoTCommandInterfaceBluetoothService: DIoTCommandInterfaceBluetoothServiceProtocol {
    
    func subscribe(subscriber: DIoTCommandInterfaceBluetoothServiceDelegate) {
        if !subscribers.contains(subscriber) {
            subscribers.add(subscriber)
        }
    }
    
    func unsubscribe(subscriber: DIoTCommandInterfaceBluetoothServiceDelegate) {
        if subscribers.contains(subscriber) {
            subscribers.remove(subscriber)
        }
    }
    
    func fetchFeatures(){
        var value = UInt8(0x01)
        let data = Data(bytes: &value, count: MemoryLayout<UInt8>.size)
        writeValue(data, for: DIoTCommandInterfaceBluetoothServiceCharacteristics.commandFeatures, type: .withoutResponse)
    }
    
    func fetchChannels(){
        var value = UInt8(0x01)
        let data = Data(bytes: &value, count: MemoryLayout<UInt8>.size)
        writeValue(data, for: DIoTCommandInterfaceBluetoothServiceCharacteristics.commandChannels, type: .withoutResponse)
    }
    
    func fetchRates(){
        var value = UInt8(0x01)
        let data = Data(bytes: &value, count: MemoryLayout<UInt8>.size)
        writeValue(data, for: DIoTCommandInterfaceBluetoothServiceCharacteristics.commandRate, type: .withoutResponse)
    }
    
    func fetchFeature(code: DIoTFeatureCode){
        var value = [UInt8(0x01), UInt8(code.rawValue)]
        let data = Data(bytes: &value, count: MemoryLayout<UInt16>.size)
        writeValue(data, for: DIoTCommandInterfaceBluetoothServiceCharacteristics.commandFeatures, type: .withoutResponse)
    }
    
    func fetchChannel(channel: Int){
        var value = [UInt8(0x01), UInt8(channel)]
        let data = Data(bytes: &value, count: MemoryLayout<UInt16>.size)
        writeValue(data, for: DIoTCommandInterfaceBluetoothServiceCharacteristics.commandChannels, type: .withoutResponse)
    }
    
    func fetchRate(channel: Int){
        var value = [UInt8(0x01), UInt8(channel)]
        let data = Data(bytes: &value, count: MemoryLayout<UInt16>.size)
        writeValue(data, for: DIoTCommandInterfaceBluetoothServiceCharacteristics.commandRate, type: .withoutResponse)
    }
    
    func notifyFeatures(enable: Bool){
        setNotifyValue(enable, for: DIoTCommandInterfaceBluetoothServiceCharacteristics.commandFeatures)
    }
    
    func notifyChannels(enable: Bool){
        setNotifyValue(enable, for: DIoTCommandInterfaceBluetoothServiceCharacteristics.commandChannels)
    }
    
    func notifyRates(enable: Bool){
        setNotifyValue(enable, for: DIoTCommandInterfaceBluetoothServiceCharacteristics.commandRate)
    }
    
    func setFeature(feature: DIoTFeatureData) {
        var par = [UInt8](DIoTFeatureData.getData(from: feature))
        var value: [UInt8] = [ 0x02, par[0],  par[1], par[2], par[3],  par[4]]
        var data = Data(bytes: &value, count: value.count)
        writeValue(data, for: DIoTCommandInterfaceBluetoothServiceCharacteristics.commandFeatures, type: .withoutResponse)
    }
    
    func cleanFeature(code: DIoTFeatureCode) {
        var value: [UInt8] = [ 0x03, UInt8(code.rawValue)]
        var data = Data(bytes: &value, count: value.count)
        writeValue(data, for: DIoTCommandInterfaceBluetoothServiceCharacteristics.commandFeatures, type: .withoutResponse)
    }
    
    func cleanFeatures() {
        var value: [UInt8] = [ 0x03 ]
        var data = Data(bytes: &value, count: value.count)
        writeValue(data, for: DIoTCommandInterfaceBluetoothServiceCharacteristics.commandFeatures, type: .withoutResponse)
    }
    
    func setChannel(channel: Int, code: DIoTFeatureCode){
        var value: [UInt8] = [ 0x02, UInt8(channel), UInt8(code.rawValue)]
        var data = Data(bytes: &value, count: value.count)
        writeValue(data, for: DIoTCommandInterfaceBluetoothServiceCharacteristics.commandChannels, type: .withoutResponse)
    }
    
    func cleanChannel(channel: Int){
        var value: [UInt8] = [ 0x03, UInt8(channel)]
        var data = Data(bytes: &value, count: value.count)
        writeValue(data, for: DIoTCommandInterfaceBluetoothServiceCharacteristics.commandChannels, type: .withoutResponse)
    }
    
    func cleanChannels() {
        var value: [UInt8] = [ 0x03 ]
        var data = Data(bytes: &value, count: value.count)
        writeValue(data, for: DIoTCommandInterfaceBluetoothServiceCharacteristics.commandChannels, type: .withoutResponse)
    }
    
    func setRate(channel: Int, rate: UInt32){
        var int = withUnsafeBytes(of: rate, Array.init)
        var value: [UInt8] = [ 0x02, UInt8(channel), int[0], int[1], int[2], int[3]]
        var data = Data(bytes: &value, count: value.count)
        writeValue(data, for: DIoTCommandInterfaceBluetoothServiceCharacteristics.commandRate, type: .withoutResponse)
    }
    
    func cleanRate(channel: Int){
        var value: [UInt8] = [ 0x03, UInt8(channel)]
        var data = Data(bytes: &value, count: value.count)
        writeValue(data, for: DIoTCommandInterfaceBluetoothServiceCharacteristics.commandRate, type: .withoutResponse)
    }
    
    func cleanRates() {
        var value: [UInt8] = [ 0x03 ]
        var data = Data(bytes: &value, count: value.count)
        writeValue(data, for: DIoTCommandInterfaceBluetoothServiceCharacteristics.commandRate, type: .withoutResponse)
    }
}

// MARK: - Handle update values
private extension DIoTCommandInterfaceBluetoothService {
    func handleUpdateValue(_ value: Data?, for characteristic: DIoTCommandInterfaceBluetoothServiceCharacteristics) {
        guard let data = value else { return }

        switch characteristic {
        case .commandFeatures: handleUpdateCommandFeaturesValue(data)
        case .commandChannels: handleUpdateCommandChannelsValue(data)
        case .commandRate: handleUpdateCommandRatesValue(data)
        }
    }

    private func handleUpdateCommandFeaturesValue(_ data: Data) {
        do {
            let value = try CommandInterfaceFeaturesParser.value(from: data)
            subscribers.forEach(as: DIoTCommandInterfaceBluetoothServiceDelegate.self) {
                $0.commandInterfaceBluetoothService(self, didReceiveCommandFeatures: value)
            }
        } catch {
            handle(error: error)
        }
    }
    
    private func handleUpdateCommandChannelsValue(_ data: Data) {
        do {
            let value = try CommandInterfaceChannelsParser.value(from: data)
            subscribers.forEach(as: DIoTCommandInterfaceBluetoothServiceDelegate.self) {
                $0.commandInterfaceBluetoothService(self, didReceiveCommandChannels: value)
            }
        } catch {
            handle(error: error)
        }
    }
    
    private func handleUpdateCommandRatesValue(_ data: Data) {
        do {
            let value = try CommandInterfaceRatesParser.value(from: data)
            subscribers.forEach(as: DIoTCommandInterfaceBluetoothServiceDelegate.self) {
                $0.commandInterfaceBluetoothService(self, didReceiveCommandRate: value)
            }
        } catch {
            handle(error: error)
        }
    }

}

// MARK: - Handle write values
private extension DIoTCommandInterfaceBluetoothService {
    func handleWriteValue(for characteristic: DIoTCommandInterfaceBluetoothServiceCharacteristics) {
        switch characteristic {
        case .commandFeatures:
            subscribers.forEach(as: DIoTCommandInterfaceBluetoothServiceDelegate.self) {
                $0.commandInterfaceBluetoothServiceDidWriteCommandFeatures(self)
            }
            break
        case .commandChannels:
            subscribers.forEach(as: DIoTCommandInterfaceBluetoothServiceDelegate.self) {
                $0.commandInterfaceBluetoothServiceDidWriteCommandChannels(self)
            }
            break
        case .commandRate:
            subscribers.forEach(as: DIoTCommandInterfaceBluetoothServiceDelegate.self) {
                $0.commandInterfaceBluetoothServiceDidWriteCommandRate(self)
            }
            break
        }
    }
}

// MARK: - Handle subscribe values
private extension DIoTCommandInterfaceBluetoothService {
    func handleUpdateSubscription(_ bluetoothCharacteristic: CBCharacteristic, _ generalCharacteristic: DIoTCommandInterfaceBluetoothServiceCharacteristics) {
        switch generalCharacteristic {
        case .commandFeatures :
            handleUpdateFeaturesSubscription(bluetoothCharacteristic)
            break
        case .commandChannels :
            handleUpdateChannelsSubscription(bluetoothCharacteristic)
            break
        case .commandRate :
            handleUpdateRatesSubscription(bluetoothCharacteristic)
            break
        }
    }
    
    private func handleUpdateFeaturesSubscription(_ characteristic: CBCharacteristic) {
        subscribers.forEach(as: DIoTCommandInterfaceBluetoothServiceDelegate.self) {
            $0.commandInterfaceBluetoothService(self, subscriptionFeaturesStatusChange: characteristic.isNotifying)
        }
    }
    
    private func handleUpdateChannelsSubscription(_ characteristic: CBCharacteristic) {
        subscribers.forEach(as: DIoTCommandInterfaceBluetoothServiceDelegate.self) {
            $0.commandInterfaceBluetoothService(self, subscriptionChannelsStatusChange: characteristic.isNotifying)
        }
    }
    
    private func handleUpdateRatesSubscription(_ characteristic: CBCharacteristic) {
        subscribers.forEach(as: DIoTCommandInterfaceBluetoothServiceDelegate.self) {
            $0.commandInterfaceBluetoothService(self, subscriptionRatesStatusChange: characteristic.isNotifying)
        }
    }
    
}

// MARK: - Handle errors
private extension DIoTCommandInterfaceBluetoothService {
    func handle(error: Error) {
        if let parseError = error as? BluetoothCharacteristicValueParserError {
            handle(parseError: parseError)
        }
    }

    private func handle(parseError: BluetoothCharacteristicValueParserError) {
        subscribers.forEach(as: DIoTCommandInterfaceBluetoothServiceDelegate.self) {
            $0.commandInterfaceBluetoothService(self, didReceiveError: .cannotParse(parseError))
        }
    }
}
