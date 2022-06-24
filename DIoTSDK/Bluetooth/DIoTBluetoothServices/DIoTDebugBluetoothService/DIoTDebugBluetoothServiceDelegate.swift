//
//  DIoTDebugBluetoothServiceDelegate.swift
//  DIoT_Demo_iOS
//
//  Created by Andrey Maslennikov on 07.04.2022.
//

public protocol DIoTDebugBluetoothServiceDelegate: class {
    /// - Parameters:
    ///   - service: debug logs service
    ///   - logs: part of logs from band
    func debugService(_ service: DIoTDebugBluetoothServiceProtocol, didReceiveLogs logs: DebugLogPart)
    func debugService(_ service: DIoTDebugBluetoothServiceProtocol, subscriptionStatusChange enabled: Bool)
}
