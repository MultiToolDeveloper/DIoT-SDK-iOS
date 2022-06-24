//
//  DeviceParserError.swift
//  DIoT_Demo_iOS
//
//  Created by Andrey Maslennikov on 07.04.2022.
//

import Foundation

public enum DeviceIdParserError {
    case uuid
    //add next more parrameters for parsing
}

// MARK: Error
extension DeviceIdParserError: Error {}

public enum DeviceIdError {
    case cannotBeParsed(DeviceIdParserError)
    case incorrectLength
}

// MARK: Error
extension DeviceIdError: Error {}
