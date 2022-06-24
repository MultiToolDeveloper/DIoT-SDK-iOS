//
//  DIoTHashTable.swift
//  DIoT_Demo_iOS
//
//  Created by Andrey Maslennikov on 07.04.2022.
//

import Foundation

public class DIoTHashTable {
    private let values = NSHashTable<AnyObject>.weakObjects()
    private let queue: DispatchQueue

    public init() {
        let identifier = "com.daatrics.DIoTHashTable.\(UUID().uuidString)"

        queue = DispatchQueue(label: identifier, attributes: .concurrent)
    }
}

// MARK: Variables
extension DIoTHashTable {
    public var isEmpty: Bool {
        var result = false

        queue.sync {
            result = self.values.allObjects.isEmpty
        }

        return result
    }
}


// MARK: Read
extension DIoTHashTable {
    public func contains(_ value: AnyObject) -> Bool {
        var result = false

        queue.sync {
            result = self.values.contains(value)
        }

        return result
    }

    public func forEach<Element>(as type: Element.Type, _ body: (Element) -> Void) {
        forEach {
            guard let element = $0 as? Element else { return }

            body(element)
        }
    }

    public func forEach(_ body: (AnyObject) -> Void) {
        queue.sync {
            self.values.allObjects.forEach(body)
        }
    }
}

// MARK: Write
extension DIoTHashTable {
    public func add(_ value: AnyObject?) {
        queue.sync {
            if !self.values.contains(value) {
                self.values.add(value)
            }
        }

        // https://stackoverflow.com/questions/41478284/discarding-message-for-event-0-because-of-too-many-unprocessed-messages-in-xcode/42145928
        // Leads to hangs on main or on open settings
        /*
        queue.async(flags: .barrier) {
            self.values.add(value)
        }
        */
    }

    // Don't call on deinit. You shoudn't pass releasing weak value to this method.
    // https://stackoverflow.com/questions/51948412/swift-how-to-check-if-an-object-is-being-released
    public func remove(_ value: AnyObject?) {
        queue.sync {
            self.values.remove(value)
        }

        // https://stackoverflow.com/questions/41478284/discarding-message-for-event-0-because-of-too-many-unprocessed-messages-in-xcode/42145928
        // Leads to hangs on main or on open settings
        /*
        queue.async(flags: .barrier) {
            self.values.remove(value)
        }
        */
    }
}
