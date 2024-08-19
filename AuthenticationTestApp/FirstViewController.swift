//
//  FirstViewController.swift
//  AuthenticationTestApp
//
//  Created by 吉原飛偉 on 2024/07/18.
//

import Foundation
import UIKit

class FirstViewController: UIViewController {
    @IBAction func signOutButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
