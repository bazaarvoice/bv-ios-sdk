# Minimum support iOS version
platform :ios, '8.0'

target 'BVSDKTests' do
  
   # cocoapods are only used for unit tests

    use_frameworks!
    #inherit! :search_paths

    # Pods for testing
    pod 'OHHTTPStubs', '~> 8.0.0'
    pod 'OHHTTPStubs/Swift'

end


post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['SWIFT_VERSION'] = '5.0'
        end
        
    end
end
