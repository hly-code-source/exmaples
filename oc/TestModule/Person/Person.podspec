
Pod::Spec.new do |s|

  s.name         = "Person"
  s.version      = "0.0.1"
  s.summary      = "Person"

  s.description  = <<-DESC
                      eaizer to use
                    DESC

  s.homepage     = "./"

  s.license      = "MIT"

  s.platform = :ios, '13.0'

  s.author       = { "helinyu" => "2319979647@qq.com" }

  s.source       = { :git => "./", :tag => "#{s.version}" }

  s.source_files = "*.{h,m}"
  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AlipaySDK-iOS'
  
  # 添加 module_map 属性
#  s.module_map       = 'module.modulemap'  # 确保路径正确
   
end
