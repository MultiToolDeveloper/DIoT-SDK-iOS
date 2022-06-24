//
//  Singleton.swift
//  DIoT_Demo_iOS
//
//  Created by Andrey Maslennikov on 25.04.2022.
//

import Foundation
import CoreBluetooth

public class DIoT {
    
//    public var DIoTSDKVersionNumber: Double
//    public var DIoTSDKVersionString: String
    
    private static var loggerService: LoggerServiceProtocol = {
        let service = LoggerService()

        service.defaults = UserDefaults.user

        return service
    }()
    
    private static var manager: CentralManagerProtocol & CentralManagerMaterializable = {
        let materializer: CentralManagerMaterializer = {
            return CBCentralManager(delegate: nil, queue: Queue.bluetoothQueue)
        }

        let service = CentralManager(materializer: materializer)
        service.materialize()
        
        return service
    }()

    public static var bluetoothManager: DIoTBluetoothStateManagerProtocol &
                                        DIoTBluetoothScanningManagerProtocol &
                                        DIoTBluetoothConnectionManagerProtocol = {
                                    
        let bluetoothManager = DIoTBluetoothManager(centralManager: manager, queue: Queue.bluetoothQueue)

        bluetoothManager.logger = loggerService

        return bluetoothManager
    }()
    
    public init() {}
    
}

// MARK: - Queues
private extension DIoT {
    enum Queue {
        static let bluetoothQueue = DispatchQueue(label: "com.diot.ble", attributes: [])
    }
}

// MARK: - UserDefaults
extension UserDefaults {
    static let application = UserDefaults(suiteName: "com.diot.defaults.application")!
    static let user = UserDefaults(suiteName: "com.diot.defaults.user")!
}

