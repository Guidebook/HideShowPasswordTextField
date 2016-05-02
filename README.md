# HideShowPasswordTextField
An easy to use `UITextField` subclass that adds a visibility toggle and an optional validation checkmark


Created by [@lookatpete](https://twitter.com/lookatpete) (product), [@pklada](https://twitter.com/pklada) (design), and [@miketsprague](https://twitter.com/miketsprague) (code)

![gif](https://s3.amazonaws.com/f.cl.ly/items/1E3Y19383s3J3g0b2Y0M/password_gif.gif?v=fc97ac97)

## Installation
### Cocoapods
`pod 'HideShowPasswordTextField', :git => 'https://github.com/Guidebook/HideShowPasswordTextField'`

### Manual
Just add the files in `HideShowPasswordTextField/` to your project.


## Usage
* Create a `UITextField` in your xib, and change the class name to `HideShowPasswordTextField`.  Or, create it programatically.
* Set `secureTextEntry` to `true`, if you want the password to hide by default.
* [Recommended] Change the border style to None, and add a height constraint of 44 or larger.  The assets in this project are optimized for 44px, although larger is fine too.  Smaller sizes might have clipping issues on the icons.
* Implement `UITextFieldDelegate` and forward `textField shouldChangeCharactersInRange` and `textFieldDidEndEditing` to your password text field (see the example).  We have to do this to get the behavior to work right--apple's API doesn't play very nice switching between `secureTextEntry` states.
* [Optional] Implement `HideShowPasswordTextFieldDelegate` to show the validation checkbox.
* Customize the textField to your liking (the tint too!)!
