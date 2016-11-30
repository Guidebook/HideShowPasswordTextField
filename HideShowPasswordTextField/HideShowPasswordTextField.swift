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

class HideShowPasswordTextField: UITextField {
    weak var passwordDelegate: HideShowPasswordTextFieldDelegate?
    var preferredFont: UIFont? {
        didSet {
            self.font = preferredFont
            
            if self.isSecureTextEntry {
                self.font = nil
            }
        }
    }
    
    override var isSecureTextEntry: Bool {
        didSet {
            if !isSecureTextEntry {
                self.font = nil
                self.font = preferredFont
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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupViews()
    }
}

// MARK: UITextFieldDelegate needed calls
// Implement UITextFieldDelegate when you use this, and forward these calls to this class!
extension HideShowPasswordTextField {
    func textField(_ textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        // Hack to prevent text from getting cleared
        // http://stackoverflow.com/a/29195723/1417922
        //Setting the new text.
        let updatedString = (textField.text as NSString?)?.replacingCharacters(in: range, with: string)
        textField.text = updatedString
        
        //Setting the cursor at the right place
        let selectedRange = NSMakeRange(range.location + string.characters.count, 0)
        let from = textField.position(from: textField.beginningOfDocument, offset:selectedRange.location)!
        let to = textField.position(from: from, offset:selectedRange.length)!
        textField.selectedTextRange = textField.textRange(from: from, to:to)
        
        //Sending an action
        textField.sendActions(for: .editingChanged)
        
        return false
    }
    
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
    func passwordTextChanged(_ sender: AnyObject) {
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
        self.rightViewMode = .whileEditing
        
        self.font = self.preferredFont
        self.addTarget(self, action: #selector(HideShowPasswordTextField.passwordTextChanged(_:)), for: .editingChanged)
        
        // if we don't do this, the eye flies in on textfield focus!
        self.rightView?.frame = self.rightViewRect(forBounds: self.bounds)
        
        // default eye state based on our initial secure text entry
        passwordToggleVisibilityView.eyeState = isSecureTextEntry ? .closed : .open
    }
}
