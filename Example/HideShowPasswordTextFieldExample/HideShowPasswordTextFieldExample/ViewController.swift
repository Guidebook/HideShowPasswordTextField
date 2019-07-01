//
//  ViewController.swift
//  HideShowPasswordTextFieldExample
//
//  Created by Mike Sprague on 5/2/16.
//  Copyright © 2016 Guidebook. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var passwordTextField: HideShowPasswordTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        setupPasswordTextField()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

// MARK: HideShowPasswordTextFieldDelegate
// Implementing this delegate is entirely optional.  
// It's useful when you want to show the user that their password is valid.
extension ViewController: HideShowPasswordTextFieldDelegate {
    func isValidPassword(_ password: String) -> Bool {
        return password.count > 7
    }
}

// MARK: Private helpers
extension ViewController {
    private func setupPasswordTextField() {
        passwordTextField.passwordDelegate = self
        passwordTextField.borderStyle = .none
        passwordTextField.clearButtonMode = .whileEditing
        passwordTextField.layer.borderWidth = 0.5
        passwordTextField.layer.borderColor = UIColor(red: 220/255.0, green: 220/255.0, blue: 220/255.0, alpha: 1.0).cgColor
        passwordTextField.borderStyle = UITextField.BorderStyle.none
        passwordTextField.clipsToBounds = true
        passwordTextField.layer.cornerRadius = 0
        
        passwordTextField.rightView?.tintColor = UIColor(red: 0.204, green: 0.624, blue: 0.847, alpha: 1)
    }
}
