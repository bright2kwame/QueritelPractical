//
//  ViewController.swift
//  QueritelPractical
//
//  Created by Bright Ahedor on 24/06/2021.
//

import UIKit
import UserNotifications

class MainViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
            if granted {
                print("Yay!")
            } else {
                print("D'oh")
            }
        }
    }


}

