#
# Be sure to run `pod lib lint ${POD_NAME}.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'KSOWebKit'
  s.version          = '1.0.1'
  s.summary          = 'KSOWebKit is a wrapper for various WebKit classes.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
*KSOWebKit* is a wrapper for various `WebKit` classes. It displays a progress interface embedded in the navigation bar and provides delegate methods to control which requests are loaded.
                       DESC

  s.homepage         = 'https://github.com/Kosoku/KSOWebKit'
  s.screenshots      = ['https://github.com/Kosoku/KSOWebKit/raw/master/screenshots/demo.gif']
  s.license          = { :type => 'BSD', :file => 'license.txt' }
  s.author           = { 'William Towe' => 'willbur1984@gmail.com' }
  s.source           = { :git => 'https://github.com/Kosoku/KSOWebKit.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '10.0'
  
  s.requires_arc = true

  s.source_files = 'KSOWebKit/**/*.{h,m}'
  s.exclude_files = 'KSOWebKit/KSOWebKit-Info.h'
  s.private_header_files = 'KSOWebKit/Private/*.h'
  
  s.resource_bundles = {
    'KSOWebKit' => ['KSOWebKit/**/*.{xcassets,lproj}']
  }

  s.frameworks = 'Foundation', 'UIKit', 'WebKit'
  
  s.dependency 'Stanley'
  s.dependency 'Ditko'
  s.dependency 'Agamotto'
  s.dependency 'KSOFontAwesomeExtensions'
end
