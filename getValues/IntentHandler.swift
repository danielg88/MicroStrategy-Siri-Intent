//
//  IntentHandler.swift
//  getValues
//
//  Created by Daniel Goncalves on 26/10/2019.
//  Copyright © 2019 Daniel Goncalves. All rights reserved.
//

import Intents

class IntentHandler: INExtension {
    
    override func handler(for intent: INIntent) -> Any {
       
        switch intent {
            case is GetValues:
                return GetValuesHandler()
            default:
                fatalError("Unhandled intent type: \(intent)")
            }
        
    }
    
}
