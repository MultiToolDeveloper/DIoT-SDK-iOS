//
//  DIoTDeviceIdBluetoothServiceDelegate.swift
//  DIoT_Demo_iOS
//
//  Created by Andrey Maslennikov on 07.04.2022.
//


public protocol DIoTDeviceIdBluetoothServiceDelegate: class {

    func deviceIdService(_ service: DIoTDeviceIdBluetoothServiceProtocol, didReceiveChipIdentifier chipIdentifier: String)

    func deviceIdService(_ service: DIoTDeviceIdBluetoothServiceProtocol, didReceiveError error: DIoTDeviceIdBluetoothServiceError)
}
