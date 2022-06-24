//
//  DIoTFeatureCode.swift
//  DIoT_Demo_iOS
//
//  Created by Andrey Maslennikov on 15.04.2022.
//

import Foundation

public enum DIoTFeatureCode: Int {
    case empty = 0
    case signalRedLed = 1
    case signalGreenLed = 2
    case signalIRLed = 3
    case heartRate = 4
    case oxigen = 5
    case respiratory = 6
    case temperature = 7
    case humidity = 8
    case accX = 9
    case accY = 10
    case accZ = 11
    case gyroX = 12
    case gyroY = 13
    case gyroZ = 14
    case alertFallDetection = 15
    case awakeLastFallAsleepDate = 16
    case awakeLastAwakeDate = 17
    case activityStepCounter = 18
    case noiseLevel = 19
    case activityLevel = 20
    case activityLevelDate = 21
    case activityDistanceTraveled = 22
    case activityCaloriesBurn = 23
    case longitude = 24
    case latitude = 25
    case altitude = 26
    case hrAlert = 27
    case hrAlertTriggerTop = 28
    case hrAlertTriggerBottom = 29
    case oxygenAlert = 30
    case oxygenAlertTriggerBottom = 31
    case temperatureAlert = 32
    case temperatureAlertTriggerTop = 33
    case temperatureAlertTriggerBottom = 34
    case humidityAlert = 35
    case humidityAlertTriggerTop = 36
    case humidityAlertTriggerBottom = 37
    case awakeAlert = 38
    case personAge = 39
    case personHeight = 40
    case personWeight = 41
    case personGender = 42
    case currentDate = 43
    
    public func getNameString() -> String{
        switch (self) {
        case .empty:
            return "empty"
        case .signalRedLed:
            return "signalRedLed"
        case .signalGreenLed:
            return "signalGreenLed"
        case .signalIRLed:
            return "signalIRLed"
        case .heartRate:
            return "heartRate"
        case .oxigen:
            return "oxigen"
        case .respiratory:
            return "respiratory"
        case .temperature:
            return "temperature"
        case .humidity:
            return "humidity"
        case .accX:
            return "accX"
        case .accY:
            return "accY"
        case .accZ:
            return "accZ"
        case .gyroX:
            return "gyroX"
        case .gyroY:
            return "gyroY"
        case .gyroZ:
            return "gyroZ"
        case .alertFallDetection:
            return "alertFallDetection"
        case .awakeLastFallAsleepDate:
            return "awakeLastFallAsleepDate"
        case .awakeLastAwakeDate:
            return "awakeLastAwakeDate"
        case .activityStepCounter:
            return "activityStepCounter"
        case .noiseLevel:
            return "noiseLevel"
        case .activityLevel:
            return "activityLevel"
        case .activityLevelDate:
            return "activityLevelDate"
        case .activityDistanceTraveled:
            return "activityDistanceTraveled"
        case .activityCaloriesBurn:
            return "activityCaloriesBurn"
        case .longitude:
            return "longitude"
        case .latitude:
            return "latitude"
        case .altitude:
            return "altitude"
        case .hrAlert:
            return "hrAlert"
        case .hrAlertTriggerTop:
            return "hrAlertTriggerTop"
        case .hrAlertTriggerBottom:
            return "hrAlertTriggerBottom"
        case .oxygenAlert:
            return "oxygenAlert"
        case .oxygenAlertTriggerBottom:
            return "oxygenAlertTriggerBottom"
        case .temperatureAlert:
            return "temperatureAlert"
        case .temperatureAlertTriggerTop:
            return "temperatureAlertTriggerTop"
        case .temperatureAlertTriggerBottom:
            return "temperatureAlertTriggerBottom"
        case .humidityAlert:
            return "humidityAlert"
        case .humidityAlertTriggerTop:
            return "humidityAlertTriggerTop"
        case .humidityAlertTriggerBottom:
            return "humidityAlertTriggerBottom"
        case .awakeAlert:
            return "awakeAlert"
        case .personAge:
            return "personAge"
        case .personHeight:
            return "personHeight"
        case .personWeight:
            return "personWeight"
        case .personGender:
            return "personGender"
        case .currentDate:
            return "currentDate"
        }
    }
}
