Pod::Spec.new do |s|
  s.name         = "SHBBannerView"
  s.version      = "0.0.1"
  s.summary      = "一个轮播图解决方案"
  s.description  = <<-DESC
    封装轮播图的实现
                   DESC
  s.homepage     = "https://github.com/jiutianhuanpei/SHBBannerView.git"
  s.license      = "MIT"
  s.author             = { "shenhongbang" => "shenhongbang@163.com" }
  s.platform     = :ios, "8.0"
  s.source       = { :git => "https://github.com/jiutianhuanpei/SHBBannerView.git", :tag => "0.0.1" }
  s.source_files  = "SHBBannerView/*"
  s.frameworks = "UIKit"
  s.dependency "SDWebImage"
  s.requires_arc = true
end
