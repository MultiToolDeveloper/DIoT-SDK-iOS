//
//  LoggerServiceError.swift
//  DIoT_Demo_iOS
//
//  Created by Andrey Maslennikov on 07.04.2022.
//

enum LoggerServiceError {
    case incorrectDate
}

// MARK: Error
extension LoggerServiceError: Error {}

// MARK: NeeboErrorProtocol
extension LoggerServiceError: DIoTErrorProtocol {}
