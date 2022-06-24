//
//  ErrorServiceBusProtocol.swift
//  DIoT_Demo_iOS
//
//  Created by Andrey Maslennikov on 07.04.2022.
//

public protocol ErrorServiceBusProtocol {
    func send(error: DIoTErrorProtocol)

    func register<ErrorMetaType>(handler: ErrorServiceBusDelegate, type: ErrorMetaType.Type)
    func unregister<ErrorMetaType>(handler: ErrorServiceBusDelegate, type: ErrorMetaType.Type)

    func register(handler: ErrorServiceBusDelegate)
    func unregister(handler: ErrorServiceBusDelegate)
}
