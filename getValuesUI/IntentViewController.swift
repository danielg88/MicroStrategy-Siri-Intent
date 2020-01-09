//
//  IntentViewController.swift
//  getValuesUI
//
//  Created by Daniel Goncalves on 26/10/2019.
//  Copyright © 2019 Daniel Goncalves. All rights reserved.
//

import IntentsUI

// As an example, this extension's Info.plist has been configured to handle interactions for INSendMessageIntent.
// You will want to replace this or add other intents as appropriate.
// The intents whose interactions you wish to handle must be declared in the extension's Info.plist.

// You can test this example integration by saying things to Siri like:
// "Send a message using <myApp>"

class IntentViewController: UIViewController, INUIHostedViewControlling {
    
    @IBOutlet var metricLabel: UILabel!
    @IBOutlet var valueLabel: UILabel!
    @IBOutlet var comparisonLabel: UILabel!
    @IBOutlet var arrowImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
        
    // MARK: - INUIHostedViewControlling
    
    // Prepare your view controller for the interaction to handle.
    func configureView(for parameters: Set<INParameter>, of interaction: INInteraction, interactiveBehavior: INUIInteractiveBehavior, context: INUIHostedViewContext, completion: @escaping (Bool, Set<INParameter>, CGSize) -> Void) {
        // Do configuration here, including preparing views and calculating a desired size for presentation.
  
        let defaults = UserDefaults(suiteName: "group.com.dgoncalves.microstrategy.siri.shared")!
        if let returnedMetric = defaults.string(forKey: "returnedMetric") {
            if let  returnedValue = defaults.value(forKey: "returnedValue") as? Double{
                if let  returnedPreviousValue = defaults.value(forKey: "returnedPreviousValue") as? Double{
                    let formatter = NumberFormatter()
                    formatter.usesGroupingSeparator = true
                    formatter.numberStyle = .currency
                    formatter.locale = Locale(identifier: "en_US")
                    formatter.maximumFractionDigits = 2
                    let valueMetricFormatted = formatter.string(for: returnedValue)!
                    
                    self.metricLabel.text = returnedMetric
                    self.valueLabel.text = valueMetricFormatted
                    
                    let calculatedPercent = (returnedValue/returnedPreviousValue)
                    formatter.maximumFractionDigits = 2
                    formatter.numberStyle = .percent
                    let formatCalculatedPercent = formatter.string(for: calculatedPercent)!
                    
                    var resultText = "A \(formatCalculatedPercent) "

                    if returnedValue > returnedPreviousValue {
                        self.arrowImage.image = UIImage(systemName: "arrow.up")
                        resultText = resultText + "increase from previous month!"
                        
                    } else {
                        self.arrowImage.image = UIImage(systemName: "arrow.down")
                        resultText = resultText + "decrease from previous month"
                    }
                    self.comparisonLabel.text = resultText
                    
                }
            }
        }
        
        
    
        completion(true, parameters, self.desiredSize)
    }

    var desiredSize: CGSize {
        let width = self.extensionContext?.hostedViewMaximumAllowedSize.width ?? 320
        print (width)
        return CGSize.init(width: width, height: 150)
    }
    
}
