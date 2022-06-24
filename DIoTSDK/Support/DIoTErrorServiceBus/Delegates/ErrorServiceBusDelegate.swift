//
//  ErrorServiceBusDelegate.swift
//  DIoT_Demo_iOS
//
//  Created by Andrey Maslennikov on 07.04.2022.
//

public protocol ErrorServiceBusDelegate: class {
    func errorServiceBus(_ esb: ErrorServiceBusProtocol, didHandleError error: DIoTErrorProtocol)
}
