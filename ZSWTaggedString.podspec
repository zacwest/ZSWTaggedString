Pod::Spec.new do |s|
  s.name             = "ZSWTaggedString"
  s.version          = "4.1"
  s.summary          = "Converts a String (or NSString) with tags (like HTML) into an NSAttributedString"
  s.description      = <<-DESC
                        Tags in a ZSWTaggedString are like HTML, except you define what they mean.
                        Read more: https://github.com/zacwest/ZSWTaggedString
                       DESC
  s.homepage         = "https://github.com/zacwest/ZSWTaggedString"
  s.license          = 'MIT'
  s.author           = { "Zachary West" => "zacwest@gmail.com" }
  s.source           = { :git => "https://github.com/zacwest/ZSWTaggedString.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/zacwest'

  s.requires_arc = true

  s.ios.deployment_target = '7.0'
  s.watchos.deployment_target = '2.0'
  s.tvos.deployment_target = '9.0'

  s.default_subspecs = 'Core'
  s.pod_target_xcconfig = { 'APPLICATION_EXTENSION_API_ONLY' => 'YES' }
  s.module_map = 'ZSWTaggedString/Classes/ZSWTaggedString.modulemap'
  s.swift_version = '4.2'

  s.subspec 'Core' do |core|
    core.source_files = 'ZSWTaggedString/Classes/**/*.{h,m}', 'ZSWTaggedString/Private/**/*.{h,m}'
    core.public_header_files = 'ZSWTaggedString/Classes/**/*.h'
    core.private_header_files = 'ZSWTaggedString/Private/**/*.h'  
  end

  s.subspec 'Swift' do |swift|
    swift.ios.deployment_target = '8.0'

    swift.dependency 'ZSWTaggedString/Core'
    swift.source_files = 'ZSWTaggedString/Classes/**/*.swift', 'ZSWTaggedString/Private/**/*.swift'
  end
end
