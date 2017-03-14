//
//  Utils.swift
//  SwiftLibrary
//
//

import Foundation
import UIKit
import CoreData

class Utils {
    
}

extension Utils {
    static func jsonToDict(_ src: NSString)-> NSDictionary?{
        let data = src.data(using: String.Encoding.utf8.rawValue)
        
        do {
            return try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions(rawValue: 0)) as? NSDictionary
        } catch let error as NSError {
            print("JSON Error \(error.localizedDescription)")
            return nil
        }
    }
    
}

extension String {
    func replace(_ string : String, replacement : String) -> String {
        return replacingOccurrences(of: string, with: replacement, options: NSString.CompareOptions.literal, range: nil)
    }
    
    func removeWhitespace() -> String {
        return replace(" ", replacement: "")
    }
}

extension UIViewController {
    func showAlertViewController(_ message : String, buttonMessage : String = "Dismiss",
                                 handler: ((UIAlertAction) -> Void)? = nil){
        let alertController = UIAlertController(title : "Library", message: message, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: buttonMessage, style: UIAlertActionStyle.default, handler: handler))
        
        present(alertController, animated: true, completion: nil)
    }
}
