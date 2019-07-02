//
//  PasswordToggleVisibilityView.swift
//  Guidebook
//
//  Created by Mike Sprague on 4/14/16.
//
//

import Foundation
import UIKit

protocol PasswordToggleVisibilityDelegate: class {
    func viewWasToggled(_ passwordToggleVisibilityView: PasswordToggleVisibilityView, isSelected selected: Bool)
}

class PasswordToggleVisibilityView: UIView {
    fileprivate let eyeOpenedImage: UIImage
    fileprivate let eyeClosedImage: UIImage
    fileprivate let checkmarkImage: UIImage
    fileprivate let eyeButton: UIButton
    fileprivate let checkmarkImageView: UIImageView
    weak var delegate: PasswordToggleVisibilityDelegate?
    
    enum EyeState {
        case open
        case closed
    }
    
    var eyeState: EyeState {
        set {
            eyeButton.isSelected = newValue == .open
        }
        get {
            return eyeButton.isSelected ? .open : .closed
        }
    }
    
    var checkmarkVisible: Bool {
        set {
            let isHidden = !newValue
            guard checkmarkImageView.isHidden != isHidden else {
                return
            }
            checkmarkImageView.isHidden = isHidden
        }
        get {
            return !checkmarkImageView.isHidden
        }
    }
    
    override var tintColor: UIColor! {
        didSet {
            eyeButton.tintColor = tintColor
            checkmarkImageView.tintColor = tintColor
        }
    }
    
    override init(frame: CGRect) {
        self.eyeOpenedImage = UIImage(named: "ic_eye_open", in: Bundle(for: PasswordToggleVisibilityView.self), compatibleWith: nil)!.withRenderingMode(.alwaysTemplate)
        self.eyeClosedImage = UIImage(named: "ic_eye_closed", in: Bundle(for: PasswordToggleVisibilityView.self), compatibleWith: nil)!.withRenderingMode(.alwaysTemplate)
        self.checkmarkImage = UIImage(named: "ic_password_checkmark", in: Bundle(for: PasswordToggleVisibilityView.self), compatibleWith: nil)!.withRenderingMode(.alwaysTemplate)
        self.eyeButton = UIButton(type: .custom)
        self.checkmarkImageView = UIImageView(image: self.checkmarkImage)
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Don't use init with coder.")
    }
    
    fileprivate func setupViews() {
        let padding: CGFloat = 10
        let buttonWidth = (frame.width / 2) - padding
        let buttonFrame = CGRect(x: buttonWidth + padding, y: 0, width: buttonWidth, height: frame.height)
        eyeButton.frame = buttonFrame
        eyeButton.backgroundColor = UIColor.clear
        eyeButton.adjustsImageWhenHighlighted = false
        eyeButton.setImage(self.eyeClosedImage, for: UIControl.State())
        eyeButton.setImage(self.eyeOpenedImage.withRenderingMode(.alwaysTemplate), for: .selected)
        eyeButton.addTarget(self, action: #selector(PasswordToggleVisibilityView.eyeButtonPressed(_:)), for: .touchUpInside)
        eyeButton.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        eyeButton.tintColor = self.tintColor
        self.addSubview(eyeButton)
        
        let checkmarkImageWidth = (frame.width / 2) - padding
        let checkmarkFrame = CGRect(x: padding, y: 0, width: checkmarkImageWidth, height: frame.height)
        checkmarkImageView.frame = checkmarkFrame
        checkmarkImageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        checkmarkImageView.contentMode = .center
        checkmarkImageView.backgroundColor = UIColor.clear
        checkmarkImageView.tintColor = self.tintColor
        self.addSubview(checkmarkImageView)
        
        self.checkmarkImageView.isHidden = true
    }
    
    
    @objc func eyeButtonPressed(_ sender: AnyObject) {
        eyeButton.isSelected = !eyeButton.isSelected
        delegate?.viewWasToggled(self, isSelected: eyeButton.isSelected)
    }
}
