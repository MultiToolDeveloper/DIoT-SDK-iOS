//
//  LoggerServiceProtocol.swift
//  DIoT_Demo_iOS
//
//  Created by Andrey Maslennikov on 07.04.2022.
//

public protocol LoggerServiceProtocol: class {
    
    var isEnabled: Bool { get set }

    func subscribe(_ subscriber: LoggerServiceDelegate)
    func unsubscribe(_ subscriber: LoggerServiceDelegate)

    func warning(_ message: String, additionalParameters: LogParameters?, file: String)
    func critical(_ message: String, additionalParameters: LogParameters?, file: String)
    func info(_ message: String, additionalParameters: LogParameters?, file: String)
    func important(_ message: String, additionalParameters: LogParameters?, file: String)
}

// Implementation by default
public extension LoggerServiceProtocol {
    func warning(_ message: String, additionalParameters: LogParameters? = nil, file: String = #file) {
        warning(message, additionalParameters: additionalParameters, file: file)
    }

    func critical(_ message: String, additionalParameters: LogParameters? = nil, file: String = #file) {
        critical(message, additionalParameters: additionalParameters, file: file)
    }

    func info(_ message: String, additionalParameters: LogParameters? = nil, file: String = #file) {
        info(message, additionalParameters: additionalParameters, file: file)
    }

    func important(_ message: String, additionalParameters: LogParameters? = nil, file: String = #file) {
        important(message, additionalParameters: additionalParameters, file: file)
    }
}
