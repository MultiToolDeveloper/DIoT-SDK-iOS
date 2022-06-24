//
//  LoggerService.swift
//  DIoT_Demo_iOS
//
//  Created by Andrey Maslennikov on 07.04.2022.
//

import Foundation

public final class LoggerService {
    
    private var subscribers = DIoTHashTable()
    public var defaults: UserDefaults!
    
    public var isEnabled: Bool {
        get {
            guard let number = defaults.object(forKey: Constants.enabledKey) as? NSNumber else {
                return Constants.enabledDefaultValue
            }

            return number.boolValue
        }

        set {
            guard isEnabled != newValue else { return }

            if !newValue {
                critical("[Logger Service] app logs disabled")
                critical("[Logger Service] app logs will be cleaned")
            }

            defaults.set(NSNumber(value: newValue), forKey: Constants.enabledKey)

            if newValue {
                critical("[Logger Service] app logs enabled")
            }
        }
    }

    public init() {}
}

// MARK: LoggerServiceProtocol
extension LoggerService: LoggerServiceProtocol {

    public func subscribe(_ subscriber: LoggerServiceDelegate) {
        subscribers.add(subscriber)
    }

    public func unsubscribe(_ subscriber: LoggerServiceDelegate) {
        subscribers.remove(subscriber)
    }

    public func warning(_ message: String, additionalParameters: LogParameters?, file: String) {
        add(log: log(with: message, file: file, type: .warning, additionalParameters: additionalParameters))
    }

    public func critical(_ message: String, additionalParameters: LogParameters?, file: String) {
        add(log: log(with: message, file: file, type: .critical, additionalParameters: additionalParameters))
    }

    public func info(_ message: String, additionalParameters: LogParameters?, file: String) {
        add(log: log(with: message, file: file, type: .info, additionalParameters: additionalParameters))
    }

    public func important(_ message: String, additionalParameters: LogParameters?, file: String) {
        add(log: log(with: message, file: file, type: .important, additionalParameters: additionalParameters))
    }
}

// MARK: Private
private extension LoggerService {
    func add(log: Log) {
        debugPrint(log.internalDebugLogString())
        
        guard isEnabled else { return }

        subscribers.forEach(as: LoggerServiceDelegate.self) {
            $0.loggerService(self, didReceive: log)
        }
    }

    func log(with message: String, file: String, type: LogType, additionalParameters: LogParameters?) -> Log {
        let fileName = ((file as NSString).lastPathComponent as NSString).deletingPathExtension

        let areParametersValid = (additionalParameters != nil) ?JSONSerialization.isValidJSONObject(additionalParameters as Any) : true

        let log = Log(uid: UUID().uuidString,
                      message: message,
                      unit: fileName,
                      createdAt: Date(),
                      type: type,
                      additionalParameters: areParametersValid ? additionalParameters : nil)

        if !areParametersValid {
            assertionFailure("[Logger service]: were passed incorrect additional parameters: \(String(describing: additionalParameters))")
        }

        return log
    }
}

// MARK: Constants
private extension LoggerService {
    enum Constants {
        static let enabledKey = "LoggerService.Defaults.isEnabled"
        static let enabledDefaultValue = true
    }
}
