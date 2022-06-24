//
//  GeneralDeviceInformationBluetoothServiceDelegate.swift
//  DIoT_Demo_iOS
//
//  Created by Andrey Maslennikov on 07.04.2022.
//

public protocol GeneralDeviceInformationBluetoothServiceDelegate: class {
    /// Method is called when service receives and successfully parses bootloader revision
    ///
    /// - Parameters:
    ///   - service: service which receives and successfully parses firmware revision
    ///   - firmwareRevision: firmware revision value. `String`
    func deviceInformationService(
        _ service: GeneralDeviceInformationBluetoothServiceProtocol,
        didReceiveFirmwareRevision firmwareRevision: String
    )

    /// Method is called when service receives and successfully parses hardware revision
    ///
    /// - Parameters:
    ///   - service: service which receives and successfully parses hardware revision
    ///   - hardwareRevision: hardware revision value. `String`
    func deviceInformationService(
        _ service: GeneralDeviceInformationBluetoothServiceProtocol,
        didReceiveHardwareRevision hardwareRevision: String
    )

    /// Method is called when service receives and successfully parses software revision
    ///
    /// - Parameters:
    ///   - service: service which receives and successfully parses software revision
    ///   - softwareRevision: software revision value. `String`
    func deviceInformationService(
        _ service: GeneralDeviceInformationBluetoothServiceProtocol,
        didReceiveSoftwareRevision softwareRevision: String
    )

    /// Method is called when service receives and successfully parses manufacture name
    ///
    /// - Parameters:
    ///   - service: service which receives and successfully parses manufacture name
    ///   - manufactureName: manufacture name value. `String`
    func deviceInformationService(
        _ service: GeneralDeviceInformationBluetoothServiceProtocol,
        didReceiveManufactureName manufactureName: String
    )

    /// Method is called when service receives and successfully parses model number
    ///
    /// - Parameters:
    ///   - service: service which receives and successfully parses model number
    ///   - modelNumber: model number value. `String`
    func deviceInformationService(
        _ service: GeneralDeviceInformationBluetoothServiceProtocol,
        didReceiveModelNumber modelNumber: String
    )
}
