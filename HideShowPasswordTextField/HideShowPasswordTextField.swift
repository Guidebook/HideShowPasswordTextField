//
//  HideShowPasswordTextField.swift
//  Guidebook
//
//  Created by Mike Sprague on 4/15/16.
//
//

import Foundation
import UIKit

protocol HideShowPasswordTextFieldDelegate: class {
    func isValidPassword(_ password: String) -> Bool
}

public class HideShowPasswordTextField: UITextField {
    weak var passwordDelegate: HideShowPasswordTextFieldDelegate?
    var preferredFont: UIFont? {
        didSet {
            self.font = nil
            if self.isSecureTextEntry {
                self.font = self.preferredFont
            }
        }
    }
    
    override public var isSecureTextEntry: Bool {
        didSet {
            if !self.isSecureTextEntry {
                self.font = nil
                self.font = self.preferredFont
            }
            
            // Hack to prevent text from getting cleared when switching secure entry
            // https://stackoverflow.com/a/49771445/1417922
            if self.isFirstResponder {
                _ = self.becomeFirstResponder()
            }
        }
    }
    fileprivate var passwordToggleVisibilityView: PasswordToggleVisibilityView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        setupViews()
    }
    
    override public func becomeFirstResponder() -> Bool {
        // Hack to prevent text from getting cleared when switching secure entry
        // https://stackoverflow.com/a/49771445/1417922
        let success = super.becomeFirstResponder()
        if self.isSecureTextEntry, let text = self.text {
            self.text?.removeAll()
            self.insertText(text)
        }
        return success
    }
}

// MARK: UITextFieldDelegate needed calls
// Implement UITextFieldDelegate when you use this, and forward these calls to this class!
extension HideShowPasswordTextField {
    func textFieldDidEndEditing(_ textField: UITextField) {
        passwordToggleVisibilityView.eyeState = PasswordToggleVisibilityView.EyeState.closed
        self.isSecureTextEntry = !isSelected
    }
}

// MARK: PasswordToggleVisibilityDelegate
extension HideShowPasswordTextField: PasswordToggleVisibilityDelegate {
    func viewWasToggled(_ passwordToggleVisibilityView: PasswordToggleVisibilityView, isSelected selected: Bool) {
        
        // hack to fix a bug with padding when switching between secureTextEntry state
        let hackString = self.text
        self.text = " "
        self.text = hackString
        
        // hack to save our correct font.  The order here is VERY finicky
        self.isSecureTextEntry = !selected
    }
}

// MARK: Control events
extension HideShowPasswordTextField {
    @objc func passwordTextChanged(_ sender: AnyObject) {
        if let password = self.text {
            passwordToggleVisibilityView.checkmarkVisible = passwordDelegate?.isValidPassword(password) ?? false
        } else {
            passwordToggleVisibilityView.checkmarkVisible = false
        }
    }
}

// MARK: Private helpers
extension HideShowPasswordTextField {
    fileprivate func setupViews() {
        let toggleFrame = CGRect(x: 0, y: 0, width: 66, height: frame.height)
        passwordToggleVisibilityView = PasswordToggleVisibilityView(frame: toggleFrame)
        passwordToggleVisibilityView.delegate = self
        passwordToggleVisibilityView.checkmarkVisible = false
        self.keyboardType = .asciiCapable
        self.rightView = passwordToggleVisibilityView
        self.font = self.preferredFont
        self.addTarget(self, action: #selector(HideShowPasswordTextField.passwordTextChanged(_:)), for: .editingChanged)
        
        // if we don't do this, the eye flies in on textfield focus!
        self.rightView?.frame = self.rightViewRect(forBounds: self.bounds)
        
        self.rightViewMode = .whileEditing
        // left view hack to add padding
        self.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 3))
        self.leftViewMode = .always
    }
}
