//
//  Data+Value.swift
//  DIoT_Demo_iOS
//
//  Created by Andrey Maslennikov on 07.04.2022.
//

import Foundation

public extension Data {
    
    func numberValue<ValueType>() -> ValueType? {
        return withUnsafeBytes({ $0.pointee })
    }

    func stringValue(encoding: String.Encoding = .utf8) -> String? {
        return String(data: self, encoding: encoding)
    }
    
    func floatValue() -> Float {
        return Float(bitPattern: UInt32(littleEndian: self.withUnsafeBytes { $0.load(as: UInt32.self) }))
    }

    func intValue() -> Int {
        return Int (UInt32(littleEndian: self.withUnsafeBytes { $0.load(as: UInt32.self) }))
    }
    
    func boolValue() -> Bool {
        return self[0] == 1
    }

}
