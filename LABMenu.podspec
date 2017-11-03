#
# Be sure to run `pod lib lint LABMenu.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'LABMenu'
  s.version          = '0.1'
  s.summary          = 'Simple left menu.'
  s.description      = "Simple Left Menu. Just create your customize menu view, and put it in."

  s.homepage         = 'https://github.com/xrax/LABMenu'
  s.screenshots      = 'https://github.com/xrax/LABMenu/blob/master/MENU.png', 'https://github.com/xrax/LABMenu/blob/master/NMenu.png'

  # ―――  Spec License  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  s.license          = { :type => 'MIT', :file => 'LICENSE' }

  # ――― Author Metadata  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  s.author             = { "Leonardo Armero Barbosa" => "limpusra@gmail.com" }

  # ――― Platform Specifics ――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  s.platform     = :ios, "11.0"
  s.pod_target_xcconfig = { 'SWIFT_VERSION' => '4' }

  # ――― Source Location ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  s.source           = { :git => 'https://github.com/xrax/LABMenu.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '10.0'

  # ――― Source Code ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  s.source_files  = 'LABMenu/*.swift', 'LABMenu/*.xib'
  
  # s.resource_bundles = {
  #   'LABMenu' => ['LABMenu/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
