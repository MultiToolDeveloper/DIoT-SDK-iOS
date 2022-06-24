//
//  Log.swift
//  DIoT_Demo_iOS
//
//  Created by Andrey Maslennikov on 07.04.2022.
//

import Foundation

public typealias LogParameters = [String: AnyHashable]

public final class Log {
    public let uid: String
    public let createdAt: Date
    public let message: String
    public let unit: String
    public let type: LogType
    public let additionalParameters: LogParameters?

    var logMessageString: String { return "\(type.string) | \(unit)] -> \(message)" }

    public init(uid: String, message: String, unit: String, createdAt: Date, type: LogType,
                additionalParameters: LogParameters?) {
        self.uid = uid
        self.message = message
        self.unit = unit
        self.createdAt = createdAt
        self.type = type
        self.additionalParameters = additionalParameters
    }

    public func logAttributedString() -> NSAttributedString {
        let timeString = self.dateString(with: Constants.timeStringFormat)

        let logString = "<\(timeString)> \(logMessageString)"

        return NSAttributedString(string: logString, attributes: [NSAttributedString.Key.foregroundColor: type.color])
    }

    public func internalDebugLogString() -> String {
        let timeString = self.dateString(with: Constants.timeStringFormat)
        var string = "<\(timeString)> \(logMessageString)"

        if let additionalParameters = additionalParameters {
            string.append(", \(additionalParameters)")
        }

        return string
    }

    public func debugLogStringToHumanFormatExport() -> String {
        guard let timeZone = TimeZone(identifier: "UTC") else {
            let dateString = self.dateString(with: Constants.dateStringFormat)
            let timeString = self.dateString(with: Constants.timeStringFormat)
            let timeZoneString = "---"

            return debugLogString(dateString: dateString, timeString: timeString, timeZoneString: timeZoneString, type: type, unit: unit, message: message, additionalParameters: additionalParameters)
        }

        let dateString = self.dateString(with: Constants.dateStringFormat, timeZone: timeZone)
        let timeString = self.dateString(with: Constants.timeStringFormat, timeZone: timeZone)
        let timeZoneString = self.dateString(with: Constants.timeZoneStringFormat)

        return debugLogString(dateString: dateString, timeString: timeString, timeZoneString: timeZoneString, type: type, unit: unit, message: message, additionalParameters: additionalParameters)
    }

    public func debugLogStringToExport() -> [String: Any] {
        let diffGMT = TimeZone.current.secondsFromGMT(for: createdAt)

        var parameters: [String: Any] = [
            "createdAt": createdAt.timeIntervalSince1970,
            "diffGMT": diffGMT,
            "message": message,
            "type": type.string,
            "unit": unit
        ]

        if let additionalParameters = additionalParameters {
            parameters.merge(additionalParameters) { (_, new) in new }
        }

        return parameters
    }
}

extension Log: Equatable {
    public static func == (lhs: Log, rhs: Log) -> Bool {
        return (lhs.uid == rhs.uid) && (lhs.createdAt == rhs.createdAt) && (lhs.unit == rhs.unit) && (lhs.type == rhs.type) && (lhs.additionalParameters == rhs.additionalParameters)
    }
}

// MARK: Private
private extension Log {
    func dateString(with format: String, timeZone: TimeZone = .current) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = timeZone
        dateFormatter.dateFormat = format

        return dateFormatter.string(from: createdAt)
    }

    func debugLogString(dateString: String, timeString: String, timeZoneString: String, type: LogType, unit: String, message: String, additionalParameters: LogParameters?) -> String {
        var string = "<\(dateString), \(timeString), \(timeZoneString)> [\(type.string), \(unit)] -> \(message)"

        if let additionalParameters = additionalParameters {
            string.append(", \(additionalParameters)")
        }

        return string
    }
}

// MARK: Constants
private extension Log {
    enum Constants {
        static let dateStringFormat = "dd.MM.yy"
        static let timeStringFormat = "HH:mm:ss"
        static let timeZoneStringFormat = "z"
    }
}

// MARK: Defaults
extension Log {
    public static let empty = Log(uid: "",
                                  message: "",
                                  unit: "",
                                  createdAt: Date(),
                                  type: .warning,
                                  additionalParameters: nil)
}
