//
//  LogType.swift
//  DIoT_Demo_iOS
//
//  Created by Andrey Maslennikov on 07.04.2022.
//

import UIKit.UIColor

public enum LogType: Int {
    case important
    case info
    case warning
    case critical
}

public extension LogType {
    var string: String {
        switch self {
        case .critical:
            return "CRITICAL"

        case .info:
            return "INFO"

        case .warning:
            return "WARNING"

        case .important:
            return "IMPROTANT"
        }
    }

    var color: UIColor {
        switch self {
        case .critical:
            return UIColor.red

        case .info:
            return UIColor.darkText

        case .warning:
            return UIColor.orange

        case .important:
            return UIColor.darkGreen
        }
    }
}

// MARK: UIColor
extension UIColor {
    static let darkGreen = UIColor(red: 0.0, green: 0.6, blue: 0.2, alpha: 1.0)
}
