Pod::Spec.new do |spec|
  spec.name = 'HideShowPasswordTextField'
  spec.version = '0.1.'
  spec.summary = 'Password visibility toggle text field'
  spec.description = 'An easy to use UITextField subclass that adds a visibility toggle and an optional validation checkmark'
  spec.homepage = 'https://github.com/Guidebook/HideShowPasswordTextField'
  spec.license = { type: 'MIT', file: 'LICENSE' }
  spec.source = { git: 'https://github.com/Guidebook/HideShowPasswordTextField', tag: "v#{spec.version}" }
  spec.author = { 'Guidebook' => 'developers@guidebook.com', 'Pete Lada' => 'peter@guidebook.com', 'Mike Sprague' => 'mike@guidebook.com', 'Pete Andersen' => 'pandersen@guidebook.com' }

  spec.platform = :ios, '8.0'
  spec.frameworks = 'UIKit'
  spec.source_files = 'HideShowPasswordTextField/*.{m,h}'
  spec.resources = ['HideShowPasswordTextField/*.{png,xib}']
end
