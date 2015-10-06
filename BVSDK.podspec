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
  s.version = '2.2.10'
  s.homepage = 'https://developer.bazaarvoice.com'
  s.license = { :type => 'Commercial', :text => 'See https://developer.bazaarvoice.com/API_Terms_of_Use' }
  s.author = { 'Bazaarvoice' => 'support@bazaarvoice.com' }
  s.source = { :git => "https://github.com/bazaarvoice/bv-ios-sdk.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/bazaarvoice'
  s.summary = 'Simple iOS SDK to interact with the Bazaarvoice platform API.'
  s.description = 'The Bazaarvoice software development kit (SDK) for iOS is an iOS static library that provides an easy way to generate REST calls to the Bazaarvoice Developer API. Using this SDK, mobile developers can quickly integrate Bazaarvoice content into their native iOS apps for iPhone and iPad on iOS 5.0 or newer.'

  s.platform = :ios, '7.0'
  s.requires_arc = true
  s.source_files = 'Pod/Classes'
  s.resource_bundles = {
    'BVSDK' => ['Pod/Assets/*.png']
  }
end
