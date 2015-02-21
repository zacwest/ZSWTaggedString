#
# Be sure to run `pod lib lint ZSWTaggedString.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# Any lines starting with a # are optional, but encouraged
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "ZSWTaggedString"
  s.version          = "0.1.0"
  s.summary          = "A short description of ZSWTaggedString."
  s.description      = <<-DESC
                       An optional longer description of ZSWTaggedString

                       * Markdown format.
                       * Don't worry about the indent, we strip it!
                       DESC
  s.homepage         = "https://github.com/zacwest/ZSWTaggedString"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = { "Zachary West" => "zacwest@gmail.com" }
  s.source           = { :git => "https://github.com/zacwest/ZSWTaggedString.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/zacwest'

  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.source_files = 'ZSWTaggedString/Classes/**/*', 'ZSWTaggedString/Private/**/*'
  s.resource_bundles = {
    'ZSWTaggedString' => ['ZSWTaggedString/Assets/*.png']
  }

  s.public_header_files = 'ZSWTaggedString/Classes/**/*.h'
  s.private_header_files = 'ZSWTaggedString/Private/**/*.h'

  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
