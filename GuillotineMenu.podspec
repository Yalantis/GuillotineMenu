Pod::Spec.new do |spec|
  spec.name = "GuillotineMenu"
  spec.version = "3.0"

  spec.homepage = "http://yalantis.com/blog/how-we-created-guillotine-menu-animation/"
  spec.summary = "Custom menu transition from Navigation Bar"

  spec.author = "Yalantis"
  spec.license = { :type => "MIT", :file => "LICENSE" }
  spec.social_media_url = "https://twitter.com/yalantis"

  spec.platform = :ios, '8.0'
  spec.ios.deployment_target = '8.0'

  spec.source = { :git => "https://github.com/Yalantis/GuillotineMenu.git", :tag => spec.version }

  spec.requires_arc = true

  spec.source_files = 'GuillotineMenu/*.swift'
  spec.requires_arc = true
end
