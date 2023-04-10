//
//  AlertEngine.swift
//  RameshWeatherApp
//
//  Created by Ramesh Guddala on 08/04/23.
//

import Foundation
import UIKit

struct AlertEngine {
    static func createErrorAlert(title: String, error: Error) -> UIAlertController {
        let alert = UIAlertController(title: title, message: error.localizedDescription, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "Ok", style: .default)
        alert.addAction(okButton)
        return alert
    }
    static func createErrorAlert(title: String, message: String) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "Ok", style: .default)
        alert.addAction(okButton)
        return alert
    }
}
