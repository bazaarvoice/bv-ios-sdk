Pod::Spec.new do |s|
  s.name         = 'BVSDK'
  s.version      = '2.2.0'
  s.license = { :type => 'Commercial', :text => 'See http://developer.bazaarvoice.com/API_Terms_of_Use' }
  s.platform     = 'ios', '5.0'
  s.summary      = 'Simple iOS SDK to interact with the Bazaarvoice platform API.'
  s.description  = 'The Bazaarvoice software development kit (SDK) for iOS is an iOS static library that provides an easy way to generate REST calls to the Bazaarvoice Developer API. Using this SDK, mobile developers can quickly integrate Bazaarvoice content into their native iOS apps for iPhone and iPad on iOS 5.0 or newer.'
  s.homepage     = 'http://developer.bazaarvoice.com'
  s.author = { 'Bazaarvoice Mobile' => 'mobilecoreteam@bazaarvoice.com' }
  s.source = { :git => "https://github.com/bazaarvoice/bv-ios-sdk.git", :tag => "v#{s.version}" }
  s.source_files = 'Source/BVSDK/BVSDK/*.{h,m}'
  s.requires_arc = true
end