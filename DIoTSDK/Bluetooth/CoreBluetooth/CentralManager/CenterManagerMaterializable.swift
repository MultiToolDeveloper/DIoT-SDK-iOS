//
//  CentralManagerMaterializable.swift
//  DIoT_Demo_iOS
//
//  Created by Andrey Maslennikov on 07.04.2022.
//

import CoreBluetooth.CBCentralManager

public typealias CentralManagerMaterializer = () -> CBCentralManager

public protocol CentralManagerMaterializable: AnyObject {
    /*
     Returns if created real CBCentralManager or not
     */
    var isMaterialized: Bool { get }

    /*
     Creates real CBCentralManager and links it to service
     */
    func materialize()
}
