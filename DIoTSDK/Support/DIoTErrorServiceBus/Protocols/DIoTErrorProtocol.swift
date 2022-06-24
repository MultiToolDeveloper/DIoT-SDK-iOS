//
//  DIoTErrorProtocol.swift
//  DIoT_Demo_iOS
//
//  Created by Andrey Maslennikov on 07.04.2022.
//

public protocol DIoTErrorProtocol {
    var localizedDescription: String { get }
}

public extension DIoTErrorProtocol {
    func object<T>() -> T? {  return self as? T }
}
