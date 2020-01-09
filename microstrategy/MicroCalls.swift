//
//  MicroCalls.swift
//  microstrategy
//
//  Created by Daniel Goncalves on 26/10/2019.
//  Copyright © 2019 Daniel Goncalves. All rights reserved.
//

import Foundation

class MicroCalls: NSObject {

func  executeLogin (username: String, password: String, loginMode: Int, baseMSTRURL: String, completion: @escaping (String) -> ()) {
    
    let loginURL = URL (string: baseMSTRURL + "auth/login")
    //create structure to hold body of login API call
    struct loginStruct: Codable {
        let username: String
        let password: String
        let loginMode: Int
        
    }
    
    //encode login data to JSON for API call
    let loginData = loginStruct(username: username, password: password, loginMode: loginMode)
    let encoder = JSONEncoder()
    let loginJSON = try? encoder.encode(loginData)
    
    //create login request
    
    var loginRequest = URLRequest(url: loginURL!)
    loginRequest.httpMethod = "POST"
    loginRequest.httpBody = loginJSON
    loginRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
    
    //create task to execute login request
    let getAuthTokenTask = URLSession.shared.dataTask(with: loginRequest) {(loginData, loginResponse, loginError) in
          
        if loginError != nil {
            // OH NO! An error occurred...
            print(loginError!)
            completion ("Failed login")
        
        }
          
        //Check if response is valid to get Auth Token
        guard let httpResponse = loginResponse as? HTTPURLResponse,
            (200...299).contains(httpResponse.statusCode) else {
                let httpResponseaux = loginResponse as? HTTPURLResponse
                print(httpResponseaux!.statusCode)
                let authToken = "Failed login"
                completion (authToken)
                return
            }
        //Getting auth token
        let authToken = httpResponse.allHeaderFields["x-mstr-authtoken"] as! String

        completion (authToken)

    }.resume()
}



func  executeReport (authToken: String, projectID: String, reportID: String, baseMSTRURL: String, completion: @escaping (Data) -> ()) {
    
    let reportURL = URL (string: baseMSTRURL + "reports/" + reportID + "/instances?limit=1000")
    
    var reportRequest = URLRequest(url: reportURL!)
    reportRequest.httpMethod = "POST"
    reportRequest.addValue(authToken, forHTTPHeaderField: "X-MSTR-AuthToken")
    reportRequest.addValue(projectID, forHTTPHeaderField: "X-MSTR-ProjectID")

    
    //create task to execute login request
    let getReportData = URLSession.shared.dataTask(with: reportRequest) {(reportData, reportResponse, reportError) in
          
        if reportError != nil {
            // OH NO! An error occurred...
            print(reportError!)
        }
          
        //Check if response is valid to get Auth Token
        guard let httpResponse = reportResponse as? HTTPURLResponse,
            (200...299).contains(httpResponse.statusCode) else {
                let httpResponseaux = reportResponse as? HTTPURLResponse
                print("Network Request Status Code: \(httpResponseaux!.statusCode)")

                let authToken = "Failed login"
                completion (reportData!)
                return
            }
        //Getting auth token
        completion (reportData!)

    }.resume()
}


}
