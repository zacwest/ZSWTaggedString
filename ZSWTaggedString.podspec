Pod::Spec.new do |s|
  s.name             = "ZSWTaggedString"
  s.version          = "1.0"
  s.summary          = "Converts an NSString with tags into an NSAttributedString"
  s.description      = <<-DESC
                        Tags in a ZSWTaggedString are like HTML, except you define what they mean.
                        Read more: https://github.com/zacwest/ZSWTaggedString
                       DESC
  s.homepage         = "https://github.com/zacwest/ZSWTaggedString"
  s.license          = 'MIT'
  s.author           = { "Zachary West" => "zacwest@gmail.com" }
  s.source           = { :git => "https://github.com/zacwest/ZSWTaggedString.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/zacwest'

  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.source_files = 'ZSWTaggedString/Classes/**/*', 'ZSWTaggedString/Private/**/*'
  s.public_header_files = 'ZSWTaggedString/Classes/**/*.h'
  s.private_header_files = 'ZSWTaggedString/Private/**/*.h'
end
