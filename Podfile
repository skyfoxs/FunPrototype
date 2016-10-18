# Uncomment this line to define a global platform for your project
# platform :ios, '9.0'

target 'FunPrototype' do

  # Comment this line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for TestMoyaSwift3
  pod 'Moya', '8.0.0-beta.2'
  
  target 'FunPrototypeTests' do
      inherit! :search_paths
      # Pods for testing
  end

  post_install do |installer|
    installer.pods_project.targets.each do |target|
      target.build_configurations.each do |config|
          config.build_settings['ENABLE_TESTABILITY'] = 'YES'
          config.build_settings['SWIFT_VERSION'] = '3.0'
      end
    end
  end
end

