#
# Be sure to run `pod lib lint comthreadsafety.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'S-Safty'
  s.version          = '0.1.3'
  s.summary          = 'Made the component of common module thread-safty simply'
  s.swift_version = '4.0'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = 'S-Safty provides some module which includes array and dictionary made thread-safty'

  s.homepage         = 'https://github.com/FelixLinBH/S-Safty'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'FelixLinBH' => 'linhandev@gmail.com' }
  s.source           = { :git => 'https://github.com/FelixLinBH/S-Safty.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'Classes/*'
  
  # s.resource_bundles = {
  #   'comthreadsafety' => ['comthreadsafety/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
