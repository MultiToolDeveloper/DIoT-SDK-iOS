//
//  DIoTResultProtocol.swift
//  DIoT_Demo_iOS
//
//  Created by Andrey Maslennikov on 07.04.2022.
//

public protocol DIoTResultProtocol {
    associatedtype SuccessType

    init(value: SuccessType)
    init(error: DIoTErrorProtocol)
}
