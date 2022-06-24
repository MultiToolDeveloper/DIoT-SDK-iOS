//
//  CBManagerState+CustomStringConvertible.swift
//  Alamofire
//
//  Created by Andrey Maslennikov on 07.04.2022.
//

import CoreBluetooth

@available(iOS 10.0, *)
extension CBManagerState: CustomStringConvertible {
    public var description: String {
        switch self {
        case .unknown: return "unknown"
        case .resetting: return "resetting"
        case .unsupported: return "unsupported"
        case .unauthorized: return "unauthorized"
        case .poweredOff: return "poweredOff"
        case .poweredOn: return "poweredOn"
        @unknown default: return "unknown default"
        }
    }
}
