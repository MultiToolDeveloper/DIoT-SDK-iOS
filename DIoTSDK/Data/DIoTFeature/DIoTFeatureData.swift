//
//  DIoTFeatureData.swift
//  DIoT_Demo_iOS
//
//  Created by Andrey Maslennikov on 26.05.2022.
//

import Foundation

public enum DIoTFeatureData {
    case empty
    case signalRedLed(Float)
    case signalGreenLed(Float)
    case signalIRLed(Float)
    case heartRate(Int)
    case oxigen(Float)
    case respiratory(Float)
    case temperature(Float)
    case humidity(Float)
    case accX(Float)
    case accY(Float)
    case accZ(Float)
    case gyroX(Float)
    case gyroY(Float)
    case gyroZ(Float)
    case alertFallDetection(Bool)
    case awakeLastFallAsleepDate(Date)
    case awakeLastAwakeDate(Date)
    case activityStepCounter(Int)
    case noiseLevel(Float)
    case activityLevel(Int)
    case activityLevelDate(Date)
    case activityDistanceTraveled(Float)
    case activityCaloriesBurn(Float)
    case longitude(Float)
    case latitude(Float)
    case altitude(Float)
    case hrAlert(Bool)
    case hrAlertTriggerTop(Int)
    case hrAlertTriggerBottom(Int)
    case oxygenAlert(Bool)
    case oxygenAlertTriggerBottom(Int)
    case temperatureAlert(Bool)
    case temperatureAlertTriggerTop(Float)
    case temperatureAlertTriggerBottom(Float)
    case humidityAlert(Bool)
    case humidityAlertTriggerTop(Float)
    case humidityAlertTriggerBottom(Float)
    case awakeAlert(Bool)
    case personAge(Int)
    case personHeight(Float)
    case personWeight(Float)
    case personGender(Bool)
    case currentDate(Date)
    
    public static func getFeature(from featureCode: DIoTFeatureCode, value: [UInt8]) -> DIoTFeatureData {
        
        let data = Data(bytes: value, count: 4)
        
        switch (featureCode){
        case .empty:
            return .empty
        case .signalRedLed:
            return .signalRedLed(data.floatValue())
        case .signalGreenLed:
            return .signalGreenLed(data.floatValue())
        case .signalIRLed:
            return .signalIRLed(data.floatValue())
        case .heartRate:
            return .heartRate(data.intValue())
        case .oxigen:
            return .oxigen(data.floatValue())
        case .respiratory:
            return .respiratory(data.floatValue())
        case .temperature:
            return .temperature(data.floatValue())
        case .humidity:
            return .humidity(data.floatValue())
        case .accX:
            return .accX(data.floatValue())
        case .accY:
            return .accY(data.floatValue())
        case .accZ:
            return .accZ(data.floatValue())
        case .gyroX:
            return .gyroX(data.floatValue())
        case .gyroY:
            return .gyroY(data.floatValue())
        case .gyroZ:
            return .gyroZ(data.floatValue())
        case .alertFallDetection:
            return .alertFallDetection(data.boolValue())
        case .awakeLastFallAsleepDate:
            let unixTime = NSDate(timeIntervalSince1970: TimeInterval(data.intValue()))
            return .awakeLastFallAsleepDate(unixTime as Date)
        case .awakeLastAwakeDate:
            let unixTime = NSDate(timeIntervalSince1970: TimeInterval(data.intValue()))
            return .awakeLastAwakeDate(unixTime as Date)
        case .activityStepCounter:
            return .activityStepCounter(data.intValue())
        case .noiseLevel:
            return .noiseLevel(data.floatValue())
        case .activityLevel:
            return .activityLevel(data.intValue())
        case .activityLevelDate:
            let unixTime = NSDate(timeIntervalSince1970: TimeInterval(data.intValue()))
            return .activityLevelDate(unixTime as Date)
        case .activityDistanceTraveled:
            return .activityDistanceTraveled(data.floatValue())
        case .activityCaloriesBurn:
            return .activityCaloriesBurn(data.floatValue())
        case .longitude:
            return .longitude(data.floatValue())
        case .latitude:
            return .latitude(data.floatValue())
        case .altitude:
            return .altitude(data.floatValue())
        case .hrAlert:
            return .hrAlert(data.boolValue())
        case .hrAlertTriggerTop:
            return .hrAlertTriggerTop(data.intValue())
        case .hrAlertTriggerBottom:
            return .hrAlertTriggerBottom(data.intValue())
        case .oxygenAlert:
            return .oxygenAlert(data.boolValue())
        case .oxygenAlertTriggerBottom:
            return .oxygenAlertTriggerBottom(data.intValue())
        case .temperatureAlert:
            return .temperatureAlert(data.boolValue())
        case .temperatureAlertTriggerTop:
            return .temperatureAlertTriggerTop(data.floatValue())
        case .temperatureAlertTriggerBottom:
            return .temperatureAlertTriggerBottom(data.floatValue())
        case .humidityAlert:
            return .humidityAlert(data.boolValue())
        case .humidityAlertTriggerTop:
            return .humidityAlertTriggerTop(data.floatValue())
        case .humidityAlertTriggerBottom:
            return .humidityAlertTriggerBottom(data.floatValue())
        case .awakeAlert:
            return .awakeAlert(data.boolValue())
        case .personAge:
            return .personAge(data.intValue())
        case .personHeight:
            return .personHeight(data.floatValue())
        case .personWeight:
            return .personWeight(data.floatValue())
        case .personGender:
            return .personGender(data.boolValue())
        case .currentDate:
            let unixTime = NSDate(timeIntervalSince1970: TimeInterval(data.intValue()))
            return .currentDate(unixTime as Date)
        }
    }
    
    public static func getData(from featureData: DIoTFeatureData) -> Data {
        
        var data = Data(count: 5)
        
        switch (featureData){
        case .empty:
            break
        case let .signalRedLed(signalRedLed):
            let arr = withUnsafeBytes(of: signalRedLed, Array.init)
            var value: [UInt8] = [ UInt8(DIoTFeatureCode.signalRedLed.rawValue), arr[0], arr[1], arr[2], arr[3]]
            data = Data(bytes: &value, count: value.count)
            break
        case let .signalGreenLed(signalGreenLed):
            let arr = withUnsafeBytes(of: signalGreenLed, Array.init)
            var value: [UInt8] = [ UInt8(DIoTFeatureCode.signalGreenLed.rawValue), arr[0], arr[1], arr[2], arr[3]]
            data = Data(bytes: &value, count: value.count)
            break
        case let .signalIRLed(signalIRLed):
            let arr = withUnsafeBytes(of: signalIRLed, Array.init)
            var value: [UInt8] = [ UInt8(DIoTFeatureCode.signalIRLed.rawValue), arr[0], arr[1], arr[2], arr[3]]
            data = Data(bytes: &value, count: value.count)
            break
        case let .heartRate(heartRate):
            let arr = withUnsafeBytes(of: heartRate, Array.init)
            var value: [UInt8] = [ UInt8(DIoTFeatureCode.heartRate.rawValue), arr[0], arr[1], arr[2], arr[3]]
            data = Data(bytes: &value, count: value.count)
            break
        case let .oxigen(oxigen):
            let arr = withUnsafeBytes(of: oxigen, Array.init)
            var value: [UInt8] = [ UInt8(DIoTFeatureCode.oxigen.rawValue), arr[0], arr[1], arr[2], arr[3]]
            data = Data(bytes: &value, count: value.count)
            break
        case let .respiratory(respiratory):
            let arr = withUnsafeBytes(of: respiratory, Array.init)
            var value: [UInt8] = [ UInt8(DIoTFeatureCode.respiratory.rawValue), arr[0], arr[1], arr[2], arr[3]]
            data = Data(bytes: &value, count: value.count)
            break
        case let .temperature(temperature):
            let arr = withUnsafeBytes(of: temperature, Array.init)
            var value: [UInt8] = [ UInt8(DIoTFeatureCode.temperature.rawValue), arr[0], arr[1], arr[2], arr[3]]
            data = Data(bytes: &value, count: value.count)
            break
        case let .humidity(humidity):
            let arr = withUnsafeBytes(of: humidity, Array.init)
            var value: [UInt8] = [ UInt8(DIoTFeatureCode.humidity.rawValue), arr[0], arr[1], arr[2], arr[3]]
            data = Data(bytes: &value, count: value.count)
            break
        case let .accX(accX):
            let arr = withUnsafeBytes(of: accX, Array.init)
            var value: [UInt8] = [ UInt8(DIoTFeatureCode.accX.rawValue), arr[0], arr[1], arr[2], arr[3]]
            data = Data(bytes: &value, count: value.count)
            break
        case let .accY(accY):
            let arr = withUnsafeBytes(of: accY, Array.init)
            var value: [UInt8] = [ UInt8(DIoTFeatureCode.accY.rawValue), arr[0], arr[1], arr[2], arr[3]]
            data = Data(bytes: &value, count: value.count)
            break
        case let .accZ(accZ):
            let arr = withUnsafeBytes(of: accZ, Array.init)
            var value: [UInt8] = [ UInt8(DIoTFeatureCode.accZ.rawValue), arr[0], arr[1], arr[2], arr[3]]
            data = Data(bytes: &value, count: value.count)
            break
        case let .gyroX(gyroX):
            let arr = withUnsafeBytes(of: gyroX, Array.init)
            var value: [UInt8] = [ UInt8(DIoTFeatureCode.gyroX.rawValue), arr[0], arr[1], arr[2], arr[3]]
            data = Data(bytes: &value, count: value.count)
            break
        case let .gyroY(gyroY):
            let arr = withUnsafeBytes(of: gyroY, Array.init)
            var value: [UInt8] = [ UInt8(DIoTFeatureCode.gyroY.rawValue), arr[0], arr[1], arr[2], arr[3]]
            data = Data(bytes: &value, count: value.count)
            break
        case let .gyroZ(gyroZ):
            let arr = withUnsafeBytes(of: gyroZ, Array.init)
            var value: [UInt8] = [ UInt8(DIoTFeatureCode.gyroZ.rawValue), arr[0], arr[1], arr[2], arr[3]]
            data = Data(bytes: &value, count: value.count)
            break
        case let .alertFallDetection(alertFallDetection):
            var value: [UInt8] = [ UInt8(DIoTFeatureCode.alertFallDetection.rawValue), 0x00, 0x00, 0x00, 0x00]
            if alertFallDetection {
                value = [ UInt8(DIoTFeatureCode.alertFallDetection.rawValue), 0x01, 0x00, 0x00, 0x00]
            }
            data = Data(bytes: &value, count: value.count)
            break
        case let .awakeLastFallAsleepDate(awakeLastFallAsleepDate):
            let arr = withUnsafeBytes(of: Int(awakeLastFallAsleepDate.timeIntervalSince1970), Array.init)
            var value: [UInt8] = [ UInt8(DIoTFeatureCode.awakeLastFallAsleepDate.rawValue), arr[0], arr[1], arr[2], arr[3]]
            data = Data(bytes: &value, count: value.count)
            break
        case let .awakeLastAwakeDate(awakeLastAwakeDate):
            let arr = withUnsafeBytes(of: Int(awakeLastAwakeDate.timeIntervalSince1970), Array.init)
            var value: [UInt8] = [ UInt8(DIoTFeatureCode.awakeLastAwakeDate.rawValue), arr[0], arr[1], arr[2], arr[3]]
            data = Data(bytes: &value, count: value.count)
            break
        case let .activityStepCounter(activityStepCounter):
            let arr = withUnsafeBytes(of: activityStepCounter, Array.init)
            var value: [UInt8] = [ UInt8(DIoTFeatureCode.activityStepCounter.rawValue), arr[0], arr[1], arr[2], arr[3]]
            data = Data(bytes: &value, count: value.count)
            break
        case let .noiseLevel(noiseLevel):
            let arr = withUnsafeBytes(of: noiseLevel, Array.init)
            var value: [UInt8] = [ UInt8(DIoTFeatureCode.noiseLevel.rawValue), arr[0], arr[1], arr[2], arr[3]]
            data = Data(bytes: &value, count: value.count)
            break
        case let .activityLevel(activityLevel):
            let arr = withUnsafeBytes(of: activityLevel, Array.init)
            var value: [UInt8] = [ UInt8(DIoTFeatureCode.activityLevel.rawValue), arr[0], arr[1], arr[2], arr[3]]
            data = Data(bytes: &value, count: value.count)
            break
        case let .activityLevelDate(activityLevelDate):
            let arr = withUnsafeBytes(of: Int(activityLevelDate.timeIntervalSince1970), Array.init)
            var value: [UInt8] = [ UInt8(DIoTFeatureCode.activityLevelDate.rawValue), arr[0], arr[1], arr[2], arr[3]]
            data = Data(bytes: &value, count: value.count)
            break
        case let .activityDistanceTraveled(activityDistanceTraveled):
            let arr = withUnsafeBytes(of: activityDistanceTraveled, Array.init)
            var value: [UInt8] = [ UInt8(DIoTFeatureCode.activityDistanceTraveled.rawValue), arr[0], arr[1], arr[2], arr[3]]
            data = Data(bytes: &value, count: value.count)
            break
        case let .activityCaloriesBurn(activityCaloriesBurn):
            let arr = withUnsafeBytes(of: activityCaloriesBurn, Array.init)
            var value: [UInt8] = [ UInt8(DIoTFeatureCode.activityCaloriesBurn.rawValue), arr[0], arr[1], arr[2], arr[3]]
            data = Data(bytes: &value, count: value.count)
            break
        case let .longitude(longitude):
            let arr = withUnsafeBytes(of: longitude, Array.init)
            var value: [UInt8] = [ UInt8(DIoTFeatureCode.longitude.rawValue), arr[0], arr[1], arr[2], arr[3]]
            data = Data(bytes: &value, count: value.count)
            break
        case let .latitude(latitude):
            let arr = withUnsafeBytes(of: latitude, Array.init)
            var value: [UInt8] = [ UInt8(DIoTFeatureCode.latitude.rawValue), arr[0], arr[1], arr[2], arr[3]]
            data = Data(bytes: &value, count: value.count)
            break
        case let .altitude(altitude):
            let arr = withUnsafeBytes(of: altitude, Array.init)
            var value: [UInt8] = [ UInt8(DIoTFeatureCode.altitude.rawValue), arr[0], arr[1], arr[2], arr[3]]
            data = Data(bytes: &value, count: value.count)
            break
        case let .hrAlert(hrAlert):
            var value: [UInt8] = [ UInt8(DIoTFeatureCode.hrAlert.rawValue), 0x00, 0x00, 0x00, 0x00]
            if hrAlert {
                value = [ UInt8(DIoTFeatureCode.hrAlert.rawValue), 0x01, 0x00, 0x00, 0x00]
            }
            data = Data(bytes: &value, count: value.count)
            break
        case let .hrAlertTriggerTop(hrAlertTriggerTop):
            let arr = withUnsafeBytes(of: hrAlertTriggerTop, Array.init)
            var value: [UInt8] = [ UInt8(DIoTFeatureCode.hrAlertTriggerTop.rawValue), arr[0], arr[1], arr[2], arr[3]]
            data = Data(bytes: &value, count: value.count)
            break
        case let .hrAlertTriggerBottom(hrAlertTriggerBottom):
            let arr = withUnsafeBytes(of: hrAlertTriggerBottom, Array.init)
            var value: [UInt8] = [ UInt8(DIoTFeatureCode.hrAlertTriggerBottom.rawValue), arr[0], arr[1], arr[2], arr[3]]
            data = Data(bytes: &value, count: value.count)
            break
        case let .oxygenAlert(oxygenAlert):
            var value: [UInt8] = [ UInt8(DIoTFeatureCode.oxygenAlert.rawValue), 0x00, 0x00, 0x00, 0x00]
            if oxygenAlert {
                value = [ UInt8(DIoTFeatureCode.oxygenAlert.rawValue), 0x01, 0x00, 0x00, 0x00]
            }
            data = Data(bytes: &value, count: value.count)
            break
        case let .oxygenAlertTriggerBottom(oxygenAlertTriggerBottom):
            let arr = withUnsafeBytes(of: oxygenAlertTriggerBottom, Array.init)
            var value: [UInt8] = [ UInt8(DIoTFeatureCode.oxygenAlertTriggerBottom.rawValue), arr[0], arr[1], arr[2], arr[3]]
            data = Data(bytes: &value, count: value.count)
            break
        case let .temperatureAlert(temperatureAlert):
            var value: [UInt8] = [ UInt8(DIoTFeatureCode.temperatureAlert.rawValue), 0x00, 0x00, 0x00, 0x00]
            if temperatureAlert {
                value = [ UInt8(DIoTFeatureCode.temperatureAlert.rawValue), 0x01, 0x00, 0x00, 0x00]
            }
            data = Data(bytes: &value, count: value.count)
            break
        case let .temperatureAlertTriggerTop(temperatureAlertTriggerTop):
            let arr = withUnsafeBytes(of: temperatureAlertTriggerTop, Array.init)
            var value: [UInt8] = [ UInt8(DIoTFeatureCode.temperatureAlertTriggerTop.rawValue), arr[0], arr[1], arr[2], arr[3]]
            data = Data(bytes: &value, count: value.count)
            break
        case let .temperatureAlertTriggerBottom(temperatureAlertTriggerBottom):
            let arr = withUnsafeBytes(of: temperatureAlertTriggerBottom, Array.init)
            var value: [UInt8] = [ UInt8(DIoTFeatureCode.temperatureAlertTriggerBottom.rawValue), arr[0], arr[1], arr[2], arr[3]]
            data = Data(bytes: &value, count: value.count)
            break
        case let .humidityAlert(humidityAlert):
            var value: [UInt8] = [ UInt8(DIoTFeatureCode.humidityAlert.rawValue), 0x00, 0x00, 0x00, 0x00]
            if humidityAlert {
                value = [ UInt8(DIoTFeatureCode.humidityAlert.rawValue), 0x01, 0x00, 0x00, 0x00]
            }
            break
        case let .humidityAlertTriggerTop(humidityAlertTriggerTop):
            let arr = withUnsafeBytes(of: humidityAlertTriggerTop, Array.init)
            var value: [UInt8] = [ UInt8(DIoTFeatureCode.humidityAlertTriggerTop.rawValue), arr[0], arr[1], arr[2], arr[3]]
            data = Data(bytes: &value, count: value.count)
            break
        case let .humidityAlertTriggerBottom(humidityAlertTriggerBottom):
            let arr = withUnsafeBytes(of: humidityAlertTriggerBottom, Array.init)
            var value: [UInt8] = [ UInt8(DIoTFeatureCode.humidityAlertTriggerBottom.rawValue), arr[0], arr[1], arr[2], arr[3]]
            data = Data(bytes: &value, count: value.count)
            break
        case let .awakeAlert(awakeAlert):
            var value: [UInt8] = [ UInt8(DIoTFeatureCode.awakeAlert.rawValue), 0x00, 0x00, 0x00, 0x00]
            if awakeAlert {
                value = [ UInt8(DIoTFeatureCode.awakeAlert.rawValue), 0x01, 0x00, 0x00, 0x00]
            }
            data = Data(bytes: &value, count: value.count)
            break
        case let .personAge(personAge):
            let arr = withUnsafeBytes(of: personAge, Array.init)
            var value: [UInt8] = [ UInt8(DIoTFeatureCode.personAge.rawValue), arr[0], arr[1], arr[2], arr[3]]
            data = Data(bytes: &value, count: value.count)
            break
        case let .personHeight(personHeight):
            let arr = withUnsafeBytes(of: personHeight, Array.init)
            var value: [UInt8] = [ UInt8(DIoTFeatureCode.personHeight.rawValue), arr[0], arr[1], arr[2], arr[3]]
            data = Data(bytes: &value, count: value.count)
            break
        case let .personWeight(personWeight):
            let arr = withUnsafeBytes(of: personWeight, Array.init)
            var value: [UInt8] = [ UInt8(DIoTFeatureCode.personWeight.rawValue), arr[0], arr[1], arr[2], arr[3]]
            data = Data(bytes: &value, count: value.count)
            break
        case let .personGender(personGender):
            let arr = withUnsafeBytes(of: personGender, Array.init)
            var value: [UInt8] = [ UInt8(DIoTFeatureCode.personGender.rawValue), arr[0], arr[1], arr[2], arr[3]]
            data = Data(bytes: &value, count: value.count)
            break
        case let .currentDate(currentDate):
            let arr = withUnsafeBytes(of: Int(currentDate.timeIntervalSince1970), Array.init)
            var value: [UInt8] = [ UInt8(DIoTFeatureCode.currentDate.rawValue), arr[0], arr[1], arr[2], arr[3]]
            data = Data(bytes: &value, count: value.count)
            break
        }
       
        return data
    }
    
    public func getNameString() -> String{
        switch (self) {
        case .empty:
            return "empty"
        case .signalRedLed(_):
            return "signalRedLed"
        case .signalGreenLed(_):
            return "signalGreenLed"
        case .signalIRLed(_):
            return "signalIRLed"
        case .heartRate(_):
            return "heartRate"
        case .oxigen(_):
            return "oxigen"
        case .respiratory(_):
            return "respiratory"
        case .temperature(_):
            return "temperature"
        case .humidity(_):
            return "humidity"
        case .accX(_):
            return "accX"
        case .accY(_):
            return "accY"
        case .accZ(_):
            return "accZ"
        case .gyroX(_):
            return "gyroX"
        case .gyroY(_):
            return "gyroY"
        case .gyroZ(_):
            return "gyroZ"
        case .alertFallDetection(_):
            return "alertFallDetection"
        case .awakeLastFallAsleepDate(_):
            return "awakeLastFallAsleepDate"
        case .awakeLastAwakeDate(_):
            return "awakeLastAwakeDate"
        case .activityStepCounter(_):
            return "activityStepCounter"
        case .noiseLevel(_):
            return "noiseLevel"
        case .activityLevel(_):
            return "activityLevel"
        case .activityLevelDate(_):
            return "activityLevelDate"
        case .activityDistanceTraveled(_):
            return "activityDistanceTraveled"
        case .activityCaloriesBurn(_):
            return "activityCaloriesBurn"
        case .longitude(_):
            return "longitude"
        case .latitude(_):
            return "latitude"
        case .altitude(_):
            return "altitude"
        case .hrAlert(_):
            return "hrAlert"
        case .hrAlertTriggerTop(_):
            return "hrAlertTriggerTop"
        case .hrAlertTriggerBottom(_):
            return "hrAlertTriggerBottom"
        case .oxygenAlert(_):
            return "oxygenAlert"
        case .oxygenAlertTriggerBottom(_):
            return "oxygenAlertTriggerBottom"
        case .temperatureAlert(_):
            return "temperatureAlert"
        case .temperatureAlertTriggerTop(_):
            return "temperatureAlertTriggerTop"
        case .temperatureAlertTriggerBottom(_):
            return "temperatureAlertTriggerBottom"
        case .humidityAlert(_):
            return "humidityAlert"
        case .humidityAlertTriggerTop(_):
            return "humidityAlertTriggerTop"
        case .humidityAlertTriggerBottom(_):
            return "humidityAlertTriggerBottom"
        case .awakeAlert(_):
            return "awakeAlert"
        case .personAge(_):
            return "personAge"
        case .personHeight(_):
            return "personHeight"
        case .personWeight(_):
            return "personWeight"
        case .personGender(_):
            return "personGender"
        case .currentDate(_):
            return "currentDate"
        }
    }
    
    public func getDataString() -> String {
        switch (self) {
        case .empty:
            return ""
        case let .signalRedLed(value):
            return "\(value)"
        case let .signalGreenLed(value):
            return "\(value)"
        case let .signalIRLed(value):
            return "\(value)"
        case let .heartRate(value):
            return "\(value)"
        case let .oxigen(value):
            return "\(value)"
        case let .respiratory(value):
            return "\(value)"
        case let .temperature(value):
            return "\(value)"
        case let .humidity(value):
            return "\(value)"
        case let .accX(value):
            return "\(value)"
        case let .accY(value):
            return "\(value)"
        case let .accZ(value):
            return "\(value)"
        case let .gyroX(value):
            return "\(value)"
        case let .gyroY(value):
            return "\(value)"
        case let .gyroZ(value):
            return "\(value)"
        case let .alertFallDetection(value):
            return "\(value)"
        case let .awakeLastFallAsleepDate(value):
            return "\(value)"
        case let .awakeLastAwakeDate(value):
            return "\(value)"
        case let .activityStepCounter(value):
            return "\(value)"
        case let .noiseLevel(value):
            return "\(value)"
        case let .activityLevel(value):
            return "\(value)"
        case let .activityLevelDate(value):
            return "\(value)"
        case let .activityDistanceTraveled(value):
            return "\(value)"
        case let .activityCaloriesBurn(value):
            return "\(value)"
        case let .longitude(value):
            return "\(value)"
        case let .latitude(value):
            return "\(value)"
        case let .altitude(value):
            return "\(value)"
        case let .hrAlert(value):
            return "\(value)"
        case let .hrAlertTriggerTop(value):
            return "\(value)"
        case let .hrAlertTriggerBottom(value):
            return "\(value)"
        case let .oxygenAlert(value):
            return "\(value)"
        case let .oxygenAlertTriggerBottom(value):
            return "\(value)"
        case let .temperatureAlert(value):
            return "\(value)"
        case let .temperatureAlertTriggerTop(value):
            return "\(value)"
        case let .temperatureAlertTriggerBottom(value):
            return "\(value)"
        case let .humidityAlert(value):
            return "\(value)"
        case let .humidityAlertTriggerTop(value):
            return "\(value)"
        case let .humidityAlertTriggerBottom(value):
            return "\(value)"
        case let .awakeAlert(value):
            return "\(value)"
        case let .personAge(value):
            return "\(value)"
        case let .personHeight(value):
            return "\(value)"
        case let .personWeight(value):
            return "\(value)"
        case let .personGender(value):
            return "\(value)"
        case let .currentDate(value):
            return "\(value)"
        }
    }
    
    public func getFeatureCode() -> DIoTFeatureCode {
        switch (self) { 
        case .empty:
            return .empty
        case .signalRedLed(_):
            return .signalRedLed
        case .signalGreenLed(_):
            return .signalGreenLed
        case .signalIRLed(_):
            return .signalIRLed
        case .heartRate(_):
            return .heartRate
        case .oxigen(_):
            return .oxigen
        case .respiratory(_):
            return .respiratory
        case .temperature(_):
            return .temperature
        case .humidity(_):
            return .humidity
        case .accX(_):
            return .accX
        case .accY(_):
            return .accY
        case .accZ(_):
            return .accZ
        case .gyroX(_):
            return .gyroX
        case .gyroY(_):
            return .gyroY
        case .gyroZ(_):
            return .gyroZ
        case .alertFallDetection(_):
            return .alertFallDetection
        case .awakeLastFallAsleepDate(_):
            return .awakeLastFallAsleepDate
        case .awakeLastAwakeDate(_):
            return .awakeLastAwakeDate
        case .activityStepCounter(_):
            return .activityStepCounter
        case .noiseLevel(_):
            return .noiseLevel
        case .activityLevel(_):
            return .activityLevel
        case .activityLevelDate(_):
            return .activityLevelDate
        case .activityDistanceTraveled(_):
            return .activityDistanceTraveled
        case .activityCaloriesBurn(_):
            return .activityCaloriesBurn
        case .longitude(_):
            return .longitude
        case .latitude(_):
            return .latitude
        case .altitude(_):
            return .altitude
        case .hrAlert(_):
            return .hrAlert
        case .hrAlertTriggerTop(_):
            return .hrAlertTriggerTop
        case .hrAlertTriggerBottom(_):
            return .hrAlertTriggerBottom
        case .oxygenAlert(_):
            return .oxygenAlert
        case .oxygenAlertTriggerBottom(_):
            return .oxygenAlertTriggerBottom
        case .temperatureAlert(_):
            return .temperatureAlert
        case .temperatureAlertTriggerTop(_):
            return .temperatureAlertTriggerTop
        case .temperatureAlertTriggerBottom(_):
            return .temperatureAlertTriggerBottom
        case .humidityAlert(_):
            return .humidityAlert
        case .humidityAlertTriggerTop(_):
            return .humidityAlertTriggerTop
        case .humidityAlertTriggerBottom(_):
            return .humidityAlertTriggerBottom
        case .awakeAlert(_):
            return .awakeAlert
        case .personAge(_):
            return .personAge
        case .personHeight(_):
            return .personHeight
        case .personWeight(_):
            return .personWeight
        case .personGender(_):
            return .personGender
        case .currentDate(_):
            return .currentDate
        }
    }
    
}
