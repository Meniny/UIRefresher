Pod::Spec.new do |s|
  s.name             = "UIRefresher"
  s.version          = "1.1.0"
  s.summary          = "Pull to refresh & pull to load more view for iOS."
  s.description      = <<-DESC
                        UIRefresher is a pull to refresh & pull to load more view for iOS..
                        DESC

  s.homepage         = "https://github.com/Meniny/UIRefresher"
  s.license          = { :type => "MIT", :file => "LICENSE.md" }
  s.author           = { "Meniny" => "Meniny@qq.com" }
  s.source           = { :git => "https://github.com/Meniny/UIRefresher.git", :tag => s.version.to_s }
  s.social_media_url = 'https://meniny.cn/'
  s.swift_version    = "5.0"

  s.ios.deployment_target = '8.0'

  s.source_files     = 'UIRefresher/**/*.*'
  # s.public_header_files = 'UIRefresher/*{.h}'
  s.frameworks       = 'Foundation', 'UIKit'
end
