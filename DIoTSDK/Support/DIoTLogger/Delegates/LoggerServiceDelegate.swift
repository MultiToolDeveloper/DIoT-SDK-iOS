//
//  LoggerServiceDelegate.swift
//  DIoT_Demo_iOS
//
//  Created by Andrey Maslennikov on 07.04.2022.
//

public protocol LoggerServiceDelegate: class {
    func loggerService(_ logger: LoggerServiceProtocol, didReceive log: Log)
}
