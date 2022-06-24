//
//  ErrorServiceBus.swift
//  DIoT_Demo_iOS
//
//  Created by Andrey Maslennikov on 07.04.2022.
//

public final class ErrorServiceBus {
    let logger: ErrorServiceBusLoggerProtocol?

    var handlers: [String: DIoTHashTable] = [:]

    public init(logger: ErrorServiceBusLoggerProtocol?) {
        self.logger = logger
    }
}

extension ErrorServiceBus: ErrorServiceBusProtocol {
    public func send(error: DIoTErrorProtocol) {
        logger?.register(error: error)

        let typeName = String(describing: type(of: error))

        handlers[typeName]?.forEach(as: ErrorServiceBusDelegate.self) {
            $0.errorServiceBus(self, didHandleError: error)
        }
    }

    public func register<ErrorMetaType>(handler: ErrorServiceBusDelegate, type: ErrorMetaType.Type) {
        let key = String(describing: type)

        if handlers[key] == nil {
            handlers[key] = DIoTHashTable()
        }

        handlers[key]?.add(handler as AnyObject)
    }

    public func unregister<ErrorMetaType>(handler: ErrorServiceBusDelegate, type: ErrorMetaType.Type) {
        let key = String(describing: type)

        guard let handlers = self.handlers[key], handlers.contains(handler as AnyObject) else { return }

        handlers.remove(handler)
    }

    public func register(handler: ErrorServiceBusDelegate) {
        for (_, handlers) in self.handlers {
            handlers.add(handler)
        }
    }

    public func unregister(handler: ErrorServiceBusDelegate) {
        let handlers = self.handlers.values.filter { return $0.contains(handler) }

        guard handlers.count > 0 else { return }

        for set in handlers {
            set.remove(handler)
        }
    }
}
