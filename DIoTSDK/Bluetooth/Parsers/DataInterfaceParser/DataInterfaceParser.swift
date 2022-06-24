//
//  DataInterfaceParser.swift
//  DIoT_Demo_iOS
//
//  Created by Andrey Maslennikov on 07.04.2022.
//

import Foundation

public final class DataInterfaceParser {
    public static func value(from data: Data) throws -> [DIoTFeatureData] {
        var features: [DIoTFeatureData] = []
        
        guard !data.isEmpty else {
            throw BluetoothCharacteristicValueParserError.cannotParse(.commandFeatures)
        }
        
        guard (data.count % 5) == 0 else {
            if data.count == 1 && data[0] == 0 {
                throw BluetoothCharacteristicValueParserError.empty
            } else {
                throw BluetoothCharacteristicValueParserError.cannotParse(.commandFeatures)
            }
        }
        
        for index in stride(from: 0, to: data.count, by: 5) {
            let featureCode = DIoTFeatureCode.init(rawValue: Int(data[index])) ?? .empty
            var dataArray: [UInt8] = []
            for i in 1...4 {
                dataArray.append(data[i + index])
            }
            
            let feature = DIoTFeatureData.getFeature(from: featureCode, value: dataArray)
            features.append(feature)
        }
        
        return features
    }

    public static func data(from value: DIoTFeatureData) -> Data {
        return DIoTFeatureData.getData(from: value)
    }
    
    private init() {}
}

