# Uncomment this line to define a global platform for your project
platform :ios, '8.0'

target 'BVSDKTests' do
  
    use_frameworks!
    #inherit! :search_paths

    # Pods for testing
    pod 'OHHTTPStubs'
    pod 'OHHTTPStubs/Swift'

end


post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['SWIFT_VERSION'] = '3.0'
        end
        
    end
end
