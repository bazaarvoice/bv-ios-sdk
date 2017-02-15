#
# Be sure to run `pod lib lint BVSDK.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# Any lines starting with a # are optional, but encouraged
#
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name = "BVSDK"
  s.version = '6.4.0'
  s.homepage = 'https://developer.bazaarvoice.com'
  s.license = { :type => 'Commercial', :text => 'See https://developer.bazaarvoice.com/API_Terms_of_Use' }
  s.author = { 'Bazaarvoice' => 'support@bazaarvoice.com' }
  s.source = { 
    :git => "https://github.com/bazaarvoice/bv-ios-sdk.git", 
    :tag => s.version.to_s 
    }
  s.social_media_url = 'https://twitter.com/bazaarvoice'
  s.summary = 'Simple iOS SDK to interact with the Bazaarvoice platform API.'
  s.description = 'The Bazaarvoice software development kit (SDK) for iOS is an iOS static library that provides an easy way to generate REST calls to the Bazaarvoice Developer API. Using this SDK, mobile developers can quickly integrate Bazaarvoice content into their native iOS apps for iPhone and iPad on iOS 8.0 or newer.'

  s.platform = :ios, '8.0'
  s.requires_arc = true
  s.default_subspec = 'Core'

  s.subspec 'Core' do |core|
     core.source_files = 'Pod/BVCommon/**/*.{h,m}', 'Pod/BVConversations/**/*.{h,m}', 'Pod/BVAnalytics/**/*.{h,m}'
  end

  s.subspec 'BVConversations' do |conversations|
    conversations.source_files = 'Pod/BVConversations/**/*.{h,m}'
    conversations.dependency 'BVSDK/Core'
  end

  s.subspec 'BVAdvertising' do |ads|
    ads.dependency 'BVSDK/Core'
  end

  s.subspec 'BVRecommendations' do |recs|
    recs.source_files = 'Pod/BVRecommendations/**/*.{h,m}'
    recs.dependency 'BVSDK/Core'
  end

  s.subspec 'BVCurations' do |curations|
    curations.source_files = 'Pod/BVCurations/**/*.{h,m}'
    curations.dependency 'BVSDK/Core'
  end

  s.subspec 'BVCurationsUI' do |curationsui|
    curationsui.source_files = 'Pod/BVCurationsUI/**/*.{h,m}'
    curationsui.dependency 'BVSDK/BVCurations'
    curationsui.resources = ["Pod/BVCurationsUI/Assets/*.xcassets"]
  end

  s.subspec 'BVLocation' do |location|
    location.source_files = 'Pod/BVLocation/**/*.{h,m}'
    location.vendored_frameworks = 'Pod/Frameworks/Gimbal.framework'
    location.library = 'z'
    location.dependency 'BVSDK/Core'
  end

  s.subspec 'BVPIN' do |pin|
    pin.source_files = 'Pod/BVPIN/**/*.{h,m}'
    pin.dependency 'BVSDK/Core'
  end

  s.subspec 'BVNotifications' do |notifications|

    notifications.source_files = 'Pod/BVNotifications/**/*.{h,m}', 'Pod/BVAnalytics/**/*.{h,m}', 'Pod/BVConversations/**/*.{h,m}', 'Pod/BVCommon/*.{h,m}','Pod/BVCommon/Private/*.{h,m}','Pod/BVCommon/Notifications/BVNotificationCenterObject.h','Pod/BVCommon/Notifications/BVStoreReviewRichNotificationCenter.{h,m}','Pod/BVCommon/Notifications/BVNotificationConstants.h','Pod/BVCommon/Notifications/BVPIN.{h,m}'
    notifications.resources = ['Pod/BVNotifications/mapThumbnail.png']

    notifications.dependency 'BVSDK/BVLocation'
    notifications.dependency 'BVSDK/BVPIN'
  end

end
