#
#  Be sure to run `pod spec lint IOSCommen.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  # ―――  Spec Metadata  ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  These will help people to find your library, and whilst it
  #  can feel like a chore to fill in it's definitely to your advantage. The
  #  summary should be tweet-length, and the description more in depth.
  #

  s.name         = "CommenOfPod"
  s.version      = "0.0.4"
  s.summary      = "CommenOfPod 用来做一些简单共用的文件"

  # This description is used to generate tags and improve search results.
  #   * Think: What does it do? Why did you write it? What is the focus?
  #   * Try to keep it short, snappy and to the point.
  #   * Write the description between the DESC delimiters below.
  #   * Finally, don't worry about the indent, CocoaPods strips it!
  s.description  = <<-DESC
                   Calendar 日历
                   PullDownList 下拉刷新表
                   NavigationMenuView #基于UIKit frameWork
                   Categray    #NSString+Additions  -fno-objc-arc
                   ImageUtils  #ASImageUtils 设置 -fno-objc-arc
                   GIFHUD
                   DESC

  s.homepage     = "https://github.com/linmingzhi/CommenOfPod"
  s.license      = "MIT"
  s.author             = { "linmingzhi987" => "linmingzhi987@126.com" }

  s.platform     = :ios
  s.platform     = :ios, "8.0"

  s.source       = { :git => "https://github.com/linmingzhi/CommenOfPod.git", :tag => "#{s.version}" }

  s.source_files  =   "Commen","Commen/Calendar", "Commen/Calendar/*.{h,m}" ,"Commen/Categray/*.{h,m}" , "Commen/MD5/*.{h,m}"  , "Commen/NavigationMenuView/*.{h,m}"  , "Commen/PullDownList/*.{h,m}"  , "Commen/UIViewExt/*.{h,m}"
#"ImageUtils/*.{h,m}"
  s.exclude_files = "Commen/Exclude"

  s.public_header_files = "Commen/**/*.h"
#"ImageUtils/*.h"

#s.subspec 'ImageUtils' do |spec|
#spec.requires_arc            = false
#spec.compiler_flags          = '-ObjC'
#end



  # s.resource  = "icon.png"
  # s.resources = "Resources/*.png"

  s.framework  = "UIKit"
  # s.frameworks = "SomeFramework", "AnotherFramework"

  # s.library   = "iconv"
  # s.libraries = "iconv", "xml2"


   s.requires_arc = true

  # s.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/libxml2" }
  # s.dependency "JSONKit", "~> 1.4"

end
