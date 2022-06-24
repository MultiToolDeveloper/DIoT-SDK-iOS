//
//  DIoTResult.swift
//  DIoT_Demo_iOS
//
//  Created by Andrey Maslennikov on 07.04.2022.
//

public enum DIoTResult<SuccessType>: DIoTResultProtocol {
    case success(SuccessType)
    case failure(DIoTErrorProtocol)

    public init(value: SuccessType) {
        self = .success(value)
    }

    public init(error: DIoTErrorProtocol) {
        self = .failure(error)
    }
}
