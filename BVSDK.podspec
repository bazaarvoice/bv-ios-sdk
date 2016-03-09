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
  s.version = '3.1.1'
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
    ads.source_files = 'Pod/BVAdvertising/**/*.{h,m}'
    # install Google Ads SDK, min of 7.6, and up to but not including 8.0
    # NOTE: When using CocooaPods with "use_frameworks!" and a Swift app you cannot have a dependency # on a library that is not dynamic. You must install the SDK manually if using BVAdvertising.
    ads.dependency 'Google-Mobile-Ads-SDK', '~> 7.6'
    ads.dependency 'BVSDK/Core'
  end

  s.subspec 'BVRecommendations' do |recs|
    recs.source_files = 'Pod/BVRecommendations/**/*.{h,m}'
    recs.dependency 'BVSDK/Core'
  end
  
s.subspec 'BVRecommendationsUI' do |recsui|
    recsui.source_files = 'Pod/BVRecommendationsUI/**/*.{h,m}'
    recsui.resource = "Pod/BVRecommendationsUI/**/*.{png,bundle,xib,nib}"
    recsui.dependency 'BVSDK/BVRecommendations'
    recsui.dependency 'SDWebImage'
    recsui.dependency 'HCSStarRatingView', '~> 1.4.3'
    recsui.dependency 'SVProgressHUD'
  end

end
