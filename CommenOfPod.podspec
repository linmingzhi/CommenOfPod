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
  s.version      = "1.1.0"
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

#s.source_files  =    "Calendar/*.{h,m}" ,"Categray/*.{h,m}" , "MD5/*.{h,m}"  , "NavigationMenuView/*.{h,m}"  , "PullDownList/*.{h,m}"  , "UIViewExt/*.{h,m}"

#s.exclude_files = "Commen/Exclude"

#s.public_header_files = "Calendar/*.h" ,"Categray/*.h" , "MD5/*.h"  , "NavigationMenuView/*.h"  , "PullDownList/*.h"  , "UIViewExt/*.h"
#"ImageUtils/*.h"

s.subspec 'Calendar' do |ss|

ss.source_files = "Calendar/*"
ss.public_header_files = "Calendar/*.h"
ss.framework  = "UIKit"

end

s.subspec 'Categray' do |ss|
ss.source_files = "Categray/*"
ss.public_header_files = "Categray/*.h"
ss.framework  = "UIKit"
end

s.subspec 'MD5' do |ss|

ss.source_files = "MD5/*"
ss.public_header_files = "MD5/*.h"

end

s.subspec 'NavigationMenuView' do |ss|

ss.source_files = "NavigationMenuView/*"
ss.public_header_files = "NavigationMenuView/*.h"
end

s.subspec 'PullDownList' do |ss|

ss.source_files = "PullDownList/*"
ss.public_header_files = "PullDownList/*.h"

end

s.subspec 'UIViewExt' do |ss|

ss.source_files = "UIViewExt/*"
ss.public_header_files = "UIViewExt/*.h"
end

s.subspec 'ImageUtils' do |ss|
ss.requires_arc            = false
ss.source_files = "ImageUtils/*"
ss.public_header_files = "ImageUtils/*.h"
end


s.subspec 'AppDelegate' do |ss|
ss.source_files = "AppDelegate/*"
ss.public_header_files = "AppDelegate/*.h"
end

s.subspec 'SDAutoLayout' do |ss|
ss.source_files = "SDAutoLayout/*"
ss.public_header_files = "SDAutoLayout/*.h"
end



  # s.resource  = "icon.png"
  # s.resources = "Resources/*.png"

  s.framework  = "UIKit" ,"QuartzCore"
  # s.frameworks = "SomeFramework", "AnotherFramework"

  # s.library   = "iconv"
  # s.libraries = "iconv", "xml2"


   s.requires_arc = true
s.dependency    "AFNetworking"
s.dependency     "MJRefresh"

  # s.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/libxml2" }
  # s.dependency "JSONKit", "~> 1.4"

end
