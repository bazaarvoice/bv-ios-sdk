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
  s.version = '9.2.0'
  s.homepage = 'https://developer.bazaarvoice.com/'
  s.license = { :type => 'Commercial', :text => 'See https://developer.bazaarvoice.com/API_Terms_of_Use' }
  s.author = { 'Bazaarvoice' => 'support@bazaarvoice.com' }
  s.source = {
    :git => "https://github.com/bazaarvoice/bv-ios-sdk.git",
    :tag => s.version.to_s
    }
  s.social_media_url = 'https://twitter.com/bazaarvoice'
  s.summary = 'Simple iOS SDK to interact with the Bazaarvoice platform API.'
  s.description = 'The Bazaarvoice software development kit (SDK) for iOS is an iOS static library that provides an easy way to generate REST calls to the Bazaarvoice Developer API. Using this SDK, mobile developers can quickly integrate Bazaarvoice content into their native iOS apps for iPhone and iPad on iOS 8.0 or newer.'

  s.platform = :ios, '15.0'
  s.requires_arc = true
  s.default_subspec = 'BVCommon'

  s.subspec 'BVCommon' do |common|
    common.source_files = 'BVSDK/BVCommon/**/*.{h,m}', 'BVSDK/BVAnalytics/**/*.{h,m}'
    common.private_header_files = 'BVSDK/BVCommon/**/Private/*.{h}', 'BVSDK/BVAnalytics/**/Private/*.{h}'
  end

  s.subspec 'BVCommonUI' do |commonui|
    commonui.source_files = 'BVSDK/BVCommonUI/**/*.{h,m}'
    commonui.private_header_files = 'BVSDK/BVCommonUI/**/Private/*.{h}'
  end

  s.subspec 'BVAnalytics' do |analytics|
    analytics.dependency 'BVSDK/BVCommon'
  end

  s.subspec 'BVConversations' do |conversations|
    conversations.source_files = 'BVSDK/BVConversations/**/*.{h,m}'
    conversations.private_header_files = 'BVSDK/BVConversations/**/Private/*.{h}'
    conversations.dependency 'BVSDK/BVCommon'
  end

  s.subspec 'BVConversationsStores' do |conversationsstores|
    conversationsstores.source_files = 'BVSDK/BVConversationsStores/**/*.{h,m}'
    conversationsstores.private_header_files = 'BVSDK/BVConversationsStores/**/Private/*.{h}'
    conversationsstores.dependency 'BVSDK/BVConversations'
  end

  s.subspec 'BVConversationsUI' do |conversationsui|
    conversationsui.source_files = 'BVSDK/BVConversationsUI/**/*.{h,m}'
    conversationsui.dependency 'BVSDK/BVCommonUI'
    conversationsui.dependency 'BVSDK/BVConversationsStores'
  end

  s.subspec 'BVCurations' do |curations|
    curations.source_files = 'BVSDK/BVCurations/**/*.{h,m}'
    curations.dependency 'BVSDK/BVCommon'
  end

  s.subspec 'BVCurationsUI' do |curationsui|
    curationsui.source_files = 'BVSDK/BVCurationsUI/**/*.{h,m}'
    curationsui.dependency 'BVSDK/BVCommon'
    curationsui.dependency 'BVSDK/BVCommonUI'
    curationsui.dependency 'BVSDK/BVCurations'
    curationsui.resources = ["BVSDK/BVCurationsUI/SocialMediaIcons/*.xcassets"]
  end

  s.subspec 'BVNotifications' do |notifications|
    notifications.source_files = 'BVSDK/BVNotifications/**/*.{h,m}'
    notifications.resources = ['BVSDK/BVNotifications/mapThumbnail.png']
    notifications.dependency 'BVSDK/BVConversationsUI'
  end

  s.subspec 'BVRecommendations' do |recs|
    recs.source_files = 'BVSDK/BVRecommendations/**/*.{h,m}'
    recs.private_header_files = 'BVSDK/BVRecommendations/**/Private/*.{h}'
    recs.dependency 'BVSDK/BVCommon'
  end

 s.subspec 'BVProductSentiments' do |sentiments|
    sentiments.source_files = 'BVSDK/BVProductSentiments/**/*.{h,m}'
    sentiments.dependency 'BVSDK/BVCommon'
  end

end
