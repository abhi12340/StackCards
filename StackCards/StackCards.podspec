Pod::Spec.new do |spec|

  spec.name         = "StackCards"
  spec.version      = "0.0.1"
  spec.summary      = "iOS Framework which provides easy way to enable the stack card using UICollectionview"
  spec.description  = "Handling Card Stack might be tideuos some time so providing the light weight StackCards framework."
  spec.homepage     = "https://github.com/abhi12340/StackCards"
  spec.license =  { :type => "MIT", :file => "LICENSE" }
  spec.author             = { "Abhishek Kumar" => "abhishekkumarthakur786@gmail.com" }
  spec.platform = :ios
  spec.ios.deployment_target  = '11.0'
  spec.requires_arc = true
  spec.source = { :git => "https://github.com/abhi12340/StackCards.git",
                  :tag => "#{spec.version}"
                }
  spec.ios.framework = "UIKit"
  spec.pod_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64' }
  spec.user_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64' }
  spec.source_files = "StackCards/**/*.{swift}"
  spec.swift_version = "5.0"
end
