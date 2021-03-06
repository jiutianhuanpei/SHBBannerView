Pod::Spec.new do |s|
  s.name         = "SHBBannerView"
  s.version      = "0.0.2"
  s.summary      = "一个轮播图解决方案"
  s.description  = <<-DESC
    封装轮播图的实现
                   DESC
  s.homepage     = "https://github.com/jiutianhuanpei/SHBBannerView.git"
  s.license      = "MIT"
  s.author             = { "shenhongbang" => "shenhongbang@163.com" }
  s.platform     = :ios, "8.0"
  s.source       = { :git => "https://github.com/jiutianhuanpei/SHBBannerView.git", :tag => "#{s.version}" }
  s.source_files  = "SHBBannerView/*.{h,m}"
  s.frameworks = "UIKit"
  s.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SRCROOT)/SDWebImage" }
  s.dependency 'SDWebImage', '~> 4.1.0'
  s.requires_arc = true
end
