//
//  GetValuesIntentHandler.swift
//  getValues
//
//  Created by Daniel Goncalves on 26/10/2019.
//  Copyright © 2019 Daniel Goncalves. All rights reserved.
//

import Foundation
import Intents

class GetValuesHandler: NSObject, GetValuesHandling {
    func handle(intent: GetValues, completion: @escaping (GetValuesResponse) -> Void) {
        
        print ("Handler")
        var returnedMetricAnswer: String = ""
        var returnedValue: Double = 0
        var returnedPreviousValue: Double = 0
        var returnedValueAnswer = INCurrencyAmount (amount: 0, currencyCode: "en_US")
        let userDefaults = UserDefaults(suiteName: "group.com.dgoncalves.microstrategy.siri.shared")!
        let metricsDictionary =  userDefaults.value(forKey: "metrics") as? [String: Double]
      
            
        guard let metric = intent.metrics else {
            return
        }

        if let metricsDictionaryaux = metricsDictionary {
            for (key,value) in metricsDictionaryaux {
                if (key == metric) {
                returnedMetricAnswer = key
                returnedValue = value //InCurrencyAmount can't be stored in UserDefaults
                returnedValueAnswer = INCurrencyAmount (amount: NSDecimalNumber (value: value), currencyCode: "USD")

                }
                if (key == metric+"_PM") {
                returnedPreviousValue = value //InCurrencyAmount can't be stored in UserDefaults
                }
            }
            

            userDefaults.set(returnedValue, forKey: "returnedValue")
            userDefaults.set(returnedMetricAnswer, forKey: "returnedMetric")
            userDefaults.set(returnedPreviousValue, forKey: "returnedPreviousValue")
            completion(GetValuesResponse.success(returnedMetric: returnedMetricAnswer, returnedValue: returnedValueAnswer))
        }
        
                
       return
                
    }
        
        
    
    func resolveMetrics(for intent: GetValues, with completion: @escaping (INStringResolutionResult) -> Void) {
        
        let userDefaults = UserDefaults(suiteName: "group.com.dgoncalves.microstrategy.siri.shared")!
        let metricsDictionary =  userDefaults.value(forKey: "metrics") as? [String: Any]
        var metricList: [String] = []
        
        if let metricsDictionaryaux = metricsDictionary {
            for (key,_) in metricsDictionaryaux {
                metricList.append(key)
            }
            guard let metric = intent.metrics else {
            completion(INStringResolutionResult.needsValue())
            return
            }
            if metricList.contains(metric){
                completion(INStringResolutionResult.success(with: metric))
                return }
            else {
            completion(INStringResolutionResult.unsupported())
            
            }
        }
    
    }

    func provideMetricsOptions(for intent: GetValues, with completion: @escaping ([String]?, Error?) -> Void) {
        
        let userDefaults = UserDefaults(suiteName: "group.com.dgoncalves.microstrategy.siri.shared")!
        let metricsDictionary =  userDefaults.value(forKey: "metrics") as? [String: Any]

        var metricList: [String] = []
        if let metricsDictionaryaux = metricsDictionary {
            for (key,_) in metricsDictionaryaux {
                if key.contains("PM") {} else {
                    metricList.append(key)}
            }
            completion(metricList,nil)
        }
        //completion(["Fail to retrieve metrics"],nil)
       
    }
    
    
}
