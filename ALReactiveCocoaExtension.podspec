#
# Be sure to run `pod lib lint ALReactiveCocoaExtension.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "ALReactiveCocoaExtension"
  s.version          = "4.1.0"
  s.summary          = "Contains replacements for the RAC and RACObserve macros in Swift and adds multiple cast methods."

  s.description      = "Contains replacements for the RAC and RACObserve macros in Swift and adds multiple cast methods which you can use to improve your ReactiveCocoa usage. It also adds wrappers around the new SignalProducer."

  s.homepage         = "https://github.com/AvdLee/ALReactiveCocoaExtension"
  s.license          = 'MIT'
  s.author           = { "Antoine van der Lee" => "ajvanderlee@gmail.com" }
  s.source           = { :git => "https://github.com/AvdLee/ALReactiveCocoaExtension.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/twannl'


  s.ios.deployment_target = '8.0'
  s.tvos.deployment_target = '9.0'
  s.watchos.deployment_target = '2.0'

  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'

  s.dependency 'Moya', '~> 8.0.0'
  s.dependency "ReactiveSwift"
  s.framework  = "Foundation"


end
