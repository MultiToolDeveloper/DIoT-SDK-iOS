//
//  DeviceId.swift
//  DIoT_Demo_iOS
//
//  Created by Andrey Maslennikov on 07.04.2022.
//

import Foundation

public final class DeviceId {
    public let uuid: UUID

    public init(uuid: UUID) {
        self.uuid = uuid
    }
}

// MARK: Hashable
extension DeviceId: Hashable {
    public var hashValue: Int {
        return ("\(uuid)").hashValue
    }
}

// MARK: Equatable
extension DeviceId: Equatable {
    public static func == (lhs: DeviceId, rhs: DeviceId) -> Bool {
        return (lhs.uuid == rhs.uuid)
    }
}

// MARK: CustomStringConvertible
extension DeviceId: CustomStringConvertible {
    public var description: String {
        return "uuid: \(uuid)"
    }
}
