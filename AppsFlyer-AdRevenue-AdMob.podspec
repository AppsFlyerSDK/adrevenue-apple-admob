Pod::Spec.new do |s|
  s.name             = 'AppsFlyer-AdRevenue-AdMob'
  s.version          = '1.0.0-beta'
  s.summary          = 'A short description of AppsFlyer-AdRevenue-AdMob.'
  s.description      = <<-DESC
AppsFlyer-AdRevenue-AdMob description. Description will be added shortly.
                       DESC

  s.homepage         = 'https://github.com/AppsFlyerSDK/adrevenue-apple-admob'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'amit.kremer' => 'amit.kremer@appsflyer.com' }
  s.source           = { :git => 'https://github.com/AppsFlyerSDK/adrevenue-apple-admob.git', :tag => s.version.to_s }

  s.ios.deployment_target = '10.0'
  
  s.vendored_frameworks = 'AppsFlyerAdRevenueAdMob.xcframework'

  s.dependency 'AppsFlyer-AdRevenue', '6.3.1'
  s.dependency 'Google-Mobile-Ads-SDK', '8.12.0'
end
