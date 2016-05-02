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
    func viewWasToggled(passwordToggleVisibilityView: PasswordToggleVisibilityView, isSelected selected: Bool)
}

class PasswordToggleVisibilityView: UIView {
    private let eyeOpenedImage: UIImage
    private let eyeClosedImage: UIImage
    private let checkmarkImage: UIImage
    private let eyeButton: UIButton
    private let checkmarkImageView: UIImageView
    weak var delegate: PasswordToggleVisibilityDelegate?
    
    enum EyeState {
        case Open
        case Closed
    }
    
    var eyeState: EyeState {
        set {
            eyeButton.selected = newValue == .Open
        }
        get {
            return eyeButton.selected ? .Open : .Closed
        }
    }
    
    var checkmarkVisible: Bool {
        set {
            checkmarkImageView.hidden = !newValue
        }
        get {
            return !checkmarkImageView.hidden
        }
    }
    
    override var tintColor: UIColor! {
        didSet {
            eyeButton.tintColor = tintColor
            checkmarkImageView.tintColor = tintColor
        }
    }
    
    override init(frame: CGRect) {
        self.eyeOpenedImage = UIImage(named: "ic_eye_open")!.imageWithRenderingMode(.AlwaysTemplate)
        self.eyeClosedImage = UIImage(named: "ic_eye_closed")!
        self.checkmarkImage = UIImage(named: "ic_password_checkmark")!.imageWithRenderingMode(.AlwaysTemplate)
        self.eyeButton = UIButton(type: .Custom)
        self.checkmarkImageView = UIImageView(image: self.checkmarkImage)
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Don't use init with coder.")
    }
    
    private func setupViews() {
        let padding: CGFloat = 10
        let buttonWidth = (CGRectGetWidth(frame) / 2) - padding
        let buttonFrame = CGRect(x: buttonWidth + padding, y: 0, width: buttonWidth, height: CGRectGetHeight(frame))
        eyeButton.frame = buttonFrame
        eyeButton.backgroundColor = UIColor.clearColor()
        eyeButton.adjustsImageWhenHighlighted = false
        eyeButton.setImage(self.eyeClosedImage, forState: .Normal)
        eyeButton.setImage(self.eyeOpenedImage.imageWithRenderingMode(.AlwaysTemplate), forState: .Selected)
        eyeButton.addTarget(self, action: #selector(eyeButtonPressed), forControlEvents: .TouchUpInside)
        eyeButton.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        eyeButton.tintColor = self.tintColor
        self.addSubview(eyeButton)
        
        let checkmarkImageWidth = (CGRectGetWidth(frame) / 2) - padding
        let checkmarkFrame = CGRect(x: padding, y: 0, width: checkmarkImageWidth, height: CGRectGetHeight(frame))
        checkmarkImageView.frame = checkmarkFrame
        checkmarkImageView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        checkmarkImageView.contentMode = .Center
        checkmarkImageView.backgroundColor = UIColor.clearColor()
        checkmarkImageView.tintColor = self.tintColor
        self.addSubview(checkmarkImageView)
    }
    
    
    @objc func eyeButtonPressed(sender: AnyObject) {
        eyeButton.selected = !eyeButton.selected
        delegate?.viewWasToggled(self, isSelected: eyeButton.selected)
    }
}

// Animation helpers