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
    func isValidPassword(password: String) -> Bool
}

class HideShowPasswordTextField: UITextField {
    weak var passwordDelegate: HideShowPasswordTextFieldDelegate?
    var preferredFont: UIFont? {
        didSet {
            self.font = preferredFont
            
            if self.secureTextEntry {
                self.font = nil
            }
        }
    }
    
    override var secureTextEntry: Bool {
        didSet {
            if !secureTextEntry {
                self.font = nil
                self.font = preferredFont
            }
        }
    }
    private var passwordToggleVisibilityView: PasswordToggleVisibilityView!
    
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
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        // Hack to prevent text from getting cleared
        // http://stackoverflow.com/a/29195723/1417922
        //Setting the new text.
        let updatedString = (textField.text as NSString?)?.stringByReplacingCharactersInRange(range, withString: string)
        textField.text = updatedString
        
        //Setting the cursor at the right place
        let selectedRange = NSMakeRange(range.location + string.characters.count, 0)
        let from = textField.positionFromPosition(textField.beginningOfDocument, offset:selectedRange.location)!
        let to = textField.positionFromPosition(from, offset:selectedRange.length)!
        textField.selectedTextRange = textField.textRangeFromPosition(from, toPosition:to)
        
        //Sending an action
        textField.sendActionsForControlEvents(.EditingChanged)
        
        return false
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        passwordToggleVisibilityView.eyeState = PasswordToggleVisibilityView.EyeState.Closed
        self.secureTextEntry = !selected
    }
}

// MARK: PasswordToggleVisibilityDelegate
extension HideShowPasswordTextField: PasswordToggleVisibilityDelegate {
    func viewWasToggled(passwordToggleVisibilityView: PasswordToggleVisibilityView, isSelected selected: Bool) {
        
        // hack to fix a bug with padding when switching between secureTextEntry state
        let hackString = self.text
        self.text = " "
        self.text = hackString
        
        // hack to save our correct font.  The order here is VERY finicky
        self.secureTextEntry = !selected
    }
}

// MARK: Control events
extension HideShowPasswordTextField {
    func passwordTextChanged(sender: AnyObject) {
        if let password = self.text {
            passwordToggleVisibilityView.checkmarkVisible = passwordDelegate?.isValidPassword(password) ?? false
        } else {
            passwordToggleVisibilityView.checkmarkVisible = false
        }
    }
}

// MARK: Private helpers
extension HideShowPasswordTextField {
    private func setupViews() {
        let toggleFrame = CGRect(x: 0, y: 0, width: 66, height: CGRectGetHeight(frame))
        passwordToggleVisibilityView = PasswordToggleVisibilityView(frame: toggleFrame)
        passwordToggleVisibilityView.delegate = self
        passwordToggleVisibilityView.checkmarkVisible = false
        
        self.keyboardType = .ASCIICapable
        self.rightView = passwordToggleVisibilityView
        self.rightViewMode = .WhileEditing
        
        self.font = self.preferredFont
        self.addTarget(self, action: #selector(HideShowPasswordTextField.passwordTextChanged(_:)), forControlEvents: .EditingChanged)
        
        // if we don't do this, the eye flies in on textfield focus!
        self.rightView?.frame = self.rightViewRectForBounds(self.bounds)
        
        // default eye state based on our initial secure text entry
        passwordToggleVisibilityView.eyeState = secureTextEntry ? .Closed : .Open
    }
}