//
//  BluetoothServiceProtocol.swift
//  DIoT_Demo_iOS
//
//  Created by Andrey Maslennikov on 07.04.2022.
//

import CoreBluetooth.CBService

/// Parent protocol for all bluetooth service protocols
public protocol BluetoothServiceProtocol: class {
    /// Bluetooth queue in which all bluetooth operations should be done
    var queue: DispatchQueue { get }

    /// Peripheral to be worked with via current service
    var peripheral: PeripheralProtocol { get }

    /// Discovered array of `CBCharacteristic` objects of current peripheral
    var characteristics: [CBCharacteristic] { get }

    /// Calls when delegate method `didUpdateValueFor` is called for current peripheral
    ///
    /// - Parameter characteristic: characteristic for which `didUpdateValueFor` was called
    func handleDidUpdateValue(for characteristic: CBCharacteristic)

    /// Calls when delegate method `didWriteValueFor` is called for current peripheral
    ///
    /// - Parameter characteristic: characteristic for which `didWriteValueFor` was called
    func handleDidWriteValue(for characteristic: CBCharacteristic)

    /// Calls when delegate method `didUpdateNotificationStateFor` is called for current peripheral
    ///
    /// - Parameter characteristic: characteristic for which `didUpdateNotificationStateFor` was called
    func handleDidUpdateNotificationState(for characteristic: CBCharacteristic)

    /// Reads value from specified characteristic
    ///
    /// - Parameter characteristic: characteristic from which value should be read
    func readValue(for characteristic: BluetoothServiceCharacteristicable)

    /// Enables or disables notifications for the characteristic’s value
    ///
    /// - Parameters:
    ///   - enabled: `Bool`
    ///   - characteristic: characteristic which should be enabled or disabled for notifications
    func setNotifyValue(_ enabled: Bool, for characteristic: BluetoothServiceCharacteristicable)

    /// Writes value (data) to specified characteristic. `CBCharacteristicWriteType` is `withResponse`
    ///
    /// - Parameters:
    ///   - data: data which should be written to characteristic
    ///   - characteristic: characteristic which should get `data`
    func writeValue(
        _ data: Data,
        for characteristic: BluetoothServiceCharacteristicable
    )

    /// Writes value (data) to specified characteristic.
    ///
    /// - Parameters:
    ///   - data: data which should be written to characteristic
    ///   - characteristic: characteristic which should get `data`
    ///   - type: `CBCharacteristicWriteType` with which write operation should be done
    func writeValue(
        _ data: Data,
        for characteristic: BluetoothServiceCharacteristicable,
        type: CBCharacteristicWriteType
    )
}
