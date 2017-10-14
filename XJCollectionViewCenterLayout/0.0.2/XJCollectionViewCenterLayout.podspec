Pod::Spec.new do |s|

  s.name          = "XJCollectionViewCenterLayout"
  s.version       = "0.0.2"
  s.summary       = "The center (i.e., Apple Music-like) layout for UICollectionView."
  s.homepage      = "https://github.com/xjimi/XJCollectionViewCenterLayout"
  s.license       = { :type => 'MIT', :file => 'LICENSE' }
  s.author        = { "XJIMI" => "fn5128@gmail.com" }
  s.source        = { :git => "https://github.com/xjimi/XJCollectionViewCenterLayout.git", :tag => "#{s.version}" }
  s.source_files  = "XJCollectionViewCenterLayout", "XJCollectionViewCenterLayout/**/*.{h,m}"
  s.framework     = 'UIKit'
  s.ios.deployment_target = '9.0'

end
