//
//  ViewController.swift
//  microstrategy
//
//  Created by Daniel Goncalves on 26/10/2019.
//  Copyright © 2019 Daniel Goncalves. All rights reserved.
//

import UIKit
import Intents

class ViewController: UIViewController {

    @IBOutlet var updateLabel: UILabel!
    @IBOutlet var refreshButton: UIButton!
    
    
    @IBAction func refreshDataButton(sender: UIButton) {
        refreshData ()
    }
    
    @objc func willEnterForeground() {
        refreshData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        donateIntent()
        NotificationCenter.default.addObserver(self, selector: #selector(willEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
        // Do any additional setup after loading the view.
    }
    
    func donateIntent () {
        let intent = GetValues()
        intent.suggestedInvocationPhrase = "Ask MicroStrategy"
        intent.metrics = "Revenue"
        let interaction = INInteraction(intent: intent, response: nil)
        
        interaction.donate { (error) in
            if error != nil {
                if let error = error as NSError? {
                    print("Interaction donation failed: %@", error)
                }
                } else {
                    print("Successfully donated interaction")
                }
            }
    }
    
    
    
    func refreshData () {
        
        let username = "YOUR_USER"
        let password = "YOUR_PASSWORD"
        let loginMode = 16 //1 Standar; 8 Guest; 16 LDAP
        let baseMSTRURL = "https://SERVER.com/MicroStrategyLibrary/api/" //Library URL
           
        let reportID = "AAAA7D3211E9F763F1300080EFB55BAA"
        let projectID = "AAAAA2F04B9FAE8D941C3E9B7E0CDAAA"

        var authToken = ""
        
        let microStrategy = MicroCalls()
        
        
        //Dispatch queue to handle async network request
        let serialQueue = DispatchQueue(label: "serialQueue")
        let serialGroup = DispatchGroup()

        var dictionary = [String: Double]()

        serialGroup.enter()

        serialQueue.async{ //add to queue
            microStrategy.executeLogin (username: username, password: password, loginMode: loginMode, baseMSTRURL: baseMSTRURL) { (authTokenAux) in
            do {
                authToken = authTokenAux
                if (authToken == "Failed Login") {}
                serialGroup.leave() //leave queue
            }

        }
        }

        serialQueue.async{
            serialGroup.wait()  //wait to be first on queue
            serialGroup.enter()
            microStrategy.executeReport (authToken: authToken, projectID: projectID, reportID: reportID, baseMSTRURL: baseMSTRURL) { (reportData) in
                do {
                    let json = try? JSONSerialization.jsonObject(with: reportData)
                    let jsonRoot = json as? [String: Any]
                    let jsonResults = jsonRoot!["result"] as? [String: Any]
                    let jsonDefinition = jsonResults!["definition"] as? [String: Any]
                    let jsonMetrics = jsonDefinition!["metrics"] as? [Any]

                    for (metric) in jsonMetrics! {
                        let metricData = metric as? [String: Any]
                        let metricMax = metricData!["max"] as? Double
                        let metricName = metricData!["name"] as? String
                        dictionary[metricName!] = metricMax
                        
                    }
                    print (dictionary)
                    let userDefaults = UserDefaults(suiteName: "group.com.dgoncalves.microstrategy.siri.shared")!
                    userDefaults.set(dictionary, forKey: "metrics")
                    print ("Data refreshed")
                    
                    DispatchQueue.main.async { // Correct
                        let currentDateTime = Date()
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "yyyy-mm-dd HH:mm:ss"
                        self.updateLabel.text = "Last Updated: " + dateFormatter.string(from: currentDateTime)
                         }
         
                }
                serialGroup.leave()
               
               
            }
        }
    }

}

