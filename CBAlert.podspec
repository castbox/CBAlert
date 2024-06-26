#
# Be sure to run `pod lib lint CBAlert.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'CBAlert'
  s.version          = '0.3.1'
  s.summary          = 'A quick alert'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/castbox/CBAlert'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'vyqrvwgf' => '515310192@qq.com' }
  s.source           = { :git => 'https://github.com/castbox/CBAlert.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '13.0'

  s.source_files = 'CBAlert/Classes/**/*'
  
  s.subspec 'Privacy' do |ss|
      ss.resource_bundles = {
        s.name => 'CBAlert/Resources/PrivacyInfo.xcprivacy'
      }
  end
end
