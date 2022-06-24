//
//  Data+Hex.swift
//  DIoT_Demo_iOS
//
//  Created by Andrey Maslennikov on 07.04.2022.
//

import Foundation

public extension Data {
    var hexString: String {
        let tokenParts = self.map { data -> String in
            return String(format: "%02.2hhx", data)
        }

        return tokenParts.joined()
    }
}
