//
//  CommandInterfaceParser.swift
//  DIoT_Demo_iOS
//
//  Created by Andrey Maslennikov on 07.04.2022.
//

import Foundation

public final class CommandInterfaceFeaturesParser {
    
    public static func value(from data: Data) throws -> [DIoTFeatureData] {
        var features: [DIoTFeatureData] = []
        
        guard !data.isEmpty else {
            throw BluetoothCharacteristicValueParserError.cannotParse(.commandFeatures)
        }
        
        guard (data.count % 5) == 0 else {
            throw BluetoothCharacteristicValueParserError.cannotParse(.commandFeatures)
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

public final class CommandInterfaceChannelsParser {
    
    public static func value(from data: Data) throws -> [DIoTChannelData] {
        var cahnnels: [DIoTChannelData] = []
        
        guard !data.isEmpty else {
            throw BluetoothCharacteristicValueParserError.cannotParse(.commandChannels)
        }
        
        guard (data.count % 2) == 0 else {
            throw BluetoothCharacteristicValueParserError.cannotParse(.commandChannels)
        }
        
        for index in stride(from: 0, to: data.count, by: 2) {
            let cahnnel = DIoTChannelData(channelNumber: Int(data[index]), feature: Int(data[index + 1]))
            cahnnels.append(cahnnel)
        }
        
        return cahnnels
    }

    public static func data(from value: DIoTChannelData) -> Data {
        var value: [UInt8] = [ UInt8(value.channelNumber), UInt8(value.feature.rawValue)]
        return Data(bytes: &value, count: value.count)
    }

    private init() {}
}

public final class CommandInterfaceRatesParser {
    
    public static func value(from data: Data) throws -> [DIoTRateData] {
        var retes: [DIoTRateData] = []
        
        guard !data.isEmpty else {
            throw BluetoothCharacteristicValueParserError.cannotParse(.commandRate)
        }
        
        guard (data.count % 5) == 0 else {
            throw BluetoothCharacteristicValueParserError.cannotParse(.commandRate)
        }
        
        for index in stride(from: 0, to: data.count, by: 5) {
            var dataArray: [UInt8] = []
            for i in 1...4 {
                dataArray.append(data[i + index])
            }
            let rateData = Data(bytes: &dataArray, count: dataArray.count)
            let rate = DIoTRateData(channelNumber: Int(data[index]), rate: rateData.intValue())
            retes.append(rate)
        }
        
        return retes
    }

    public static func data(from value: DIoTRateData) -> Data {
        let arr = withUnsafeBytes(of: value.rate, Array.init)
        var value: [UInt8] = [ UInt8(value.channelNumber), arr[0], arr[1], arr[2], arr[3]]
        return Data(bytes: &value, count: value.count)
    }

    private init() {}
}

public final class DIoTChannelData {
    public var channelNumber: Int
    public var feature: DIoTFeatureCode
    
    public init(channelNumber: Int, feature: Int){
        self.channelNumber = channelNumber
        self.feature = DIoTFeatureCode.init(rawValue: feature) ?? .empty
    }   
}

public final class DIoTRateData {
    public var channelNumber: Int
    public var rate: Int
    
    public init(channelNumber: Int, rate: Int){
        self.channelNumber = channelNumber
        self.rate = rate
    }
}
